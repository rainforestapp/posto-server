class UserProfile < ActiveRecord::Base
  include AppendOnlyModel

  #attr_accessible :birthday, :email, :first_name, :gender, :last_name, :location, :middle_name, :name, :user_id
  belongs_to :user
  mark_latest_within_scope :user_id

end
