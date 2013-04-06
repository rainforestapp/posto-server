class CreditPromoState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :credit_promo
  valid_states :pending, :granted
end
