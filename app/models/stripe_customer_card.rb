class StripeCustomerCard < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState

  attr_accessible :stripe_card

  belongs_to_and_marks_latest_within :stripe_customer
  belongs_to :stripe_card

  has_audited_state_through :stripe_customer_card_state

  def active?
    self.state == :active && !self.stripe_card.expired?
  end

  def declined?
    self.state == :declined
  end

  def expired?
    self.stripe_card.expired?
  end

  def mark_as_removed!
    self.state = :removed
  end

  def mark_as_declined!
    self.state = :declined
  end
end
