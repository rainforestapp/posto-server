class CardPrintingState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :card_printing
  valid_states :created, :pending_mailing, :confirmed, :cancelled
end
