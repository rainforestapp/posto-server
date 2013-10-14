class DelayedPromoCardState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :delayed_promo_card
  valid_states :pending, :processed
end
