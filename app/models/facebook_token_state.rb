class FacebookTokenState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :facebook_token
  valid_states :active, :expired
end
