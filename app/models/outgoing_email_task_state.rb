class OutgoingEmailTaskState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :outgoing_email_task
  valid_states :outgoing, :sent, :opened, :clicked
end
