class BirthdayRequestFacebookThread < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :facebook_thread_id, :thread_update_time
  belongs_to_and_marks_latest_within :address_request

end

