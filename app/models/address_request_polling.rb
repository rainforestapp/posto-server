class AddressRequestPolling < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :address_request_id, :poll_date, :poll_index, :previous_address_request_polling_id
end
