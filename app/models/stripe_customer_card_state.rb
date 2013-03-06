class StripeCustomerCardState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel
  after_save :invalidate_payment_info_state!

  belongs_to_and_marks_latest_within :stripe_customer_card
  valid_states :active, :removed, :declined

  def invalidate_payment_info_state!
    stripe_customer_card.invalidate_payment_info_state!
  end
end
