class BirthdayRequestState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :birthday_request
  valid_states :outgoing, :sent, :closed, :failed
end

