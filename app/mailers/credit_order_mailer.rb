class CreditOrderMailer < ActionMailer::Base
  default from: "lulcards orders <orders@lulcards.com>"
  layout "email"

  def credit_order_receipt(credit_order)
    with_address_for_credit_order(credit_order, :orderer) do |recipient_address|
      if credit_order.is_gift?
        mail(to: recipient_address,
            from: @from,
            subject: "Your #{@app.name} purchase for #{credit_order.recipient_name}")
      else
        mail(to: recipient_address,
            from: @from,
            subject: "Receipt for your #{@app.name} purchase")
      end
    end
  end

  def giftee_receipt(credit_order)
    return unless credit_order.is_gift?

    with_address_for_credit_order(credit_order, :recipient) do |recipient_address|
      mail(to: recipient_address,
           from: @from,
           subject: "#{credit_order.orderer_name} sent you #{credit_order.credits} #{credit_order.app.name} credits")
    end
  end

  def admin_audit_credit_order(credit_order)
    @credit_order = credit_order
    @app = credit_order.app
    @config = CONFIG.for_app(@app)
    @from = @config.from_email

    return unless @config.admin_credit_order_enabled

    mail(to: @config.admin_credit_order_audit_email,
         from: @from,
         subject: "[POSTO CREDITS] #{@credit_order.credits} Credit Order ##{@credit_order.credit_order_id}")
  end
  
  def credit_plan_payment_receipt(credit_plan_payment)
    @credit_plan_membership = credit_play_payment.credit_plan_membership
    @credit_plan_payment = credit_plan_payment
    @user = @credit_plan_membership.user
    @app = @credit_plan_membership.app
    @profile = @user.user_profile
    @config = CONFIG.for_app(@app)

    return unless @profile

    recipient_email_address = "#{@profile.name} <#{@profile.email}>"

    if Rails.env == "development"
      recipient_email_address = "gfodor@gmail.com"
    end

    mail(to: recipient_email_address,
         from: @config.from_email,
         subject: "Your #{@app.name} credits receipt")
  end

  def with_address_for_credit_order(credit_order, address_type)
    @credit_order = credit_order
    @app = credit_order.app
    @config = CONFIG.for_app(@app)
    @from = @config.from_email
    
    recipient_email_address, recipient_name = nil

    if address_type == :orderer
      recipient_email_address = credit_order.orderer_email
      recipient_name = credit_order.orderer_name
    else
      recipient_email_address = credit_order.recipient_email
      recipient_name = credit_order.recipient_name
    end

    if Rails.env == "development"
      recipient_email_address = "gfodor@gmail.com"
    end

    if recipient_email_address && recipient_name
      yield "#{recipient_name} <#{recipient_email_address}>"
    elsif recipient_email_address
      yield recipient_email_address
    end
  end
end

