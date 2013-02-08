class StripeCustomerCardState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :stripe_customer_card
  valid_states :active, :removed, :declined
end
