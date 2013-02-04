class AddressRequest < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :address_request_medium, :address_request_payload, :app_id, :recipient_user_id, :sender_user_id
end
