class CreditPlanPayment < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :credit_plan_membership_id, :due_date

  belongs_to :credit_plan_membership

  has_audited_state_through :credit_plan_payment_state

  def self.find_due_payments(*args)
    options = args.extract_options!
    due_on = options[:on] || Time.now
    since = options[:since] || 1.week

    payments = CreditPlanPayment.where(due_date: (due_on - since)..due_on)
    payments.select(&:pending?).select { |p| p.credit_plan_membership.active? }
  end

  def due?
    self.due_date < Time.now
  end

  def pay_if_due!(force = false)
    return false unless (due? && pending?) || force
    return false unless self.credit_plan_membership.active?

    # Sanity check
    app = self.credit_plan_membership.app
    user = self.credit_plan_membership.user

    current_membership = user.credit_plan_membership_for_app(app)
    return false unless self.credit_plan_membership == current_membership

    failed = false

    fail_unless = lambda do |flag, &block| 
      if flag
        block.call
      else
        failed = true
      end
    end

    plan = self.credit_plan_membership
    user = plan.user
    app = plan.app
    stripe_customer = user.stripe_customer

    fail_unless.call(stripe_customer) do
      customer = Stripe::Customer.retrieve(stripe_customer.stripe_id)

      fail_unless.call(customer && customer["active_card"]) do
        charge = nil

        begin
          charge = Stripe::Charge.create(
            amount: plan.credit_plan_price,
            currency: "usd",
            customer: customer["id"],
            description: "Charge #{plan.credit_plan_credits} Plan Credits"
          )
        rescue
          begin
            stripe_customer.stripe_customer_card.mark_as_declined!
            stripe_customer.stripe_customer_card.append_to_metadata!(message: e.message)
          rescue Exception => ex
          end

          failed = true
        end

        if charge["failure_message"]
          if stripe_customer && stripe_customer.stripe_card
            begin
              stripe_customer.stripe_customer_card.mark_as_declined!
              stripe_customer.stripe_customer_card.append_to_metadata!(message: e.message)
            rescue Exception => e
            end
          end

          failed = true
        end

        unless failed
          begin
            User.transaction_with_retry do
              user.add_credits!(plan.credit_plan_credits, 
                                app: app, 
                                source_type: :credit_plan_payment, 
                                source_id: self.credit_plan_payment_id)
            end
          rescue Exception => e
            Airbrake.notify_or_ignore(e)
            charge.refund rescue nil
            failed = true
          end
        end

        begin
          CreditOrderMailer.credit_plan_payment_receipt(self).try(:deliver)
        rescue Exception => e
          Airbrake.notify_or_ignore(e)
        end
      end
    end

    unless failed
      mark_as_paid!
    else
      # TODO need to notify them card was denied, have path to fix
      mark_as_failed!
    end

    return !failed
  end

  def pending?
    self.state == :pending
  end

  def mark_as_paid!
    self.state = :paid
  end

  def mark_as_failed!
    self.state = :failed
  end

  def order_number
    10000 + (self.credit_plan_payment_id * 17)
  end
end
