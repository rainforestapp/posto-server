class CardOrderState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :card_order
  valid_states :created, :pending_address_requests, :pending_payment, :pending_printing, :pending_mailing, :failed, :finished
end
