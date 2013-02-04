class AddressRequestState < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :address_request_id, :state
end
