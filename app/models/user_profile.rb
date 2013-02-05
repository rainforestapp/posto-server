class UserProfile < ActiveRecord::Base
  include AppendOnlyModel

  #attr_accessible :birthday, :email, :first_name, :gender, :last_name, :location, :middle_name, :name, :user_id
  belongs_to_and_marks_latest_within :user

end
