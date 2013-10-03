class CreditPlanMembershipState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :credit_plan_membership
  valid_states :active, :cancelled

  after_save :invalidate_credit_plan_membership_state!

  def invalidate_credit_plan_membership_state!
    credit_plan_membership.invalidate_credit_plan_membership_state!
  end
end
