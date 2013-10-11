class CreditPlanMembership < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited
  include TransactionRetryable

  NUMBER_OF_PAYMENT_YEARS_TO_GENERATE = 5

  attr_accessible :app_id, :credit_plan_id, :credit_plan_credits, :credit_plan_price

  belongs_to :user
  belongs_to :app

  has_audited_state_through :credit_plan_membership_state

  after_save :invalidate_credit_plan_membership_state!

  has_many :credit_plan_payments

  def self.find_memberships_without_payments
    sql = <<-END
      select credit_plan_membership_id from credit_plan_memberships a where
        not exists (select credit_plan_payment_id from credit_plan_payments where credit_plan_membership_id = a.credit_plan_membership_id)
    END

    results = CreditPlanMembership.connection.execute(sql)

    ids = []

    results.each do |result|
      ids << result[0]
    end

    CreditPlanMembership.find(ids)
  end

  def invalidate_credit_plan_membership_state!
    user.invalidate_credit_plan_membership_state!
  end

  def active?
    self.state == :active
  end

  def cancel!
    self.state = :cancelled
  end

  def printable_total_price
    "$%.02f" % (self.credit_plan_price / 100.0) 
  end

  def generate_payments!
    return unless self.credit_plan_payments.size == 0

    CreditPlanMembership.transaction_with_retry do 
      1.upto(NUMBER_OF_PAYMENT_YEARS_TO_GENERATE * 12) do |offset|
        self.credit_plan_payments.create!(
          due_date: self.created_at + offset.months
        )
      end
    end
  end
end
