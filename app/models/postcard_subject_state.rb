class PostcardSubjectState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :postcard_subject
  valid_states :active, :removed
end
