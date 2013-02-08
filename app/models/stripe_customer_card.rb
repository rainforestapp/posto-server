class StripeCustomerCard < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState

  attr_accessible :stripe_card

  belongs_to_and_marks_latest_within :stripe_customer
  belongs_to :stripe_card

  has_audited_state_through :stripe_customer_card_state

  def mark_as_removed!
    self.state = :removed
  end
end
