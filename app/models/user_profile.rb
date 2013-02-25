class UserProfile < ActiveRecord::Base
  include AppendOnlyModel

  FACEBOOK_FIELDS = %w(id name first_name middle_name last_name location gender email birthday)

  belongs_to_and_marks_latest_within :user
end
