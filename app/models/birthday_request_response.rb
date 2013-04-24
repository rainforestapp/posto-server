class BirthdayRequestResponse < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :recipient_user_id, :sender_user_id, :birthday

  belongs_to_and_marks_latest_within :recipient_user, class_name: "User"
  belongs_to :sender_user, class_name: "User"
  belongs_to :address_request

  before_save do
    User.invalidate_birthday_for_user_id(self.recipient_user_id)
  end
end
