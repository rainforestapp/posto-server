class EmailOptOutState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :email_opt_out
  valid_states :opted_out, :not_opted_out
end
