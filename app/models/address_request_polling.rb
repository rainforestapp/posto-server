class AddressRequestPolling < ActiveRecord::Base
  include AppendOnlyModel

  belongs_to_and_marks_latest_within :address_request
  belongs_to :previous_address_request_polling, class_name: "AddressRequestPolling"

  before_create do
    self.poll_index = (self.previous_address_request_polling.try(:poll_index) || 0) + 1
  end
end
