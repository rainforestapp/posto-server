class CreditPlanPayment < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :credit_plan_membership_id, :due_date

  belongs_to :credit_plan_membership

  has_audited_state_through :credit_plan_payment_state
end
