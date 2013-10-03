class CreditPlanMembership < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :app_id, :credit_plan_id, :credit_plan_credits, :credit_plan_price

  belongs_to :user
  belongs_to :app

  has_audited_state_through :credit_plan_membership_state

  after_save :invalidate_credit_plan_membership_state!

  def invalidate_credit_plan_membership_state!
    user.invalidate_credit_plan_membership_state!
  end

  def active?
    self.state == :active
  end

  def cancel!
    self.state = :cancelled
  end
end
