class AddressResponse < ActiveRecord::Base
  include AppendOnlyModel
    #attr_accessible :address_api_response_id, :response_raw_text, :response_source_id, :response_source_type, :address_request_id
end
