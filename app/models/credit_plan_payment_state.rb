class CreditPlanPaymentState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :credit_plan_payment
  valid_states :pending, :paid, :failed
end
