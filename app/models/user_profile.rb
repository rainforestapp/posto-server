class UserProfile < ActiveRecord::Base
  include AppendOnlyModel

  belongs_to_and_marks_latest_within :user
end
