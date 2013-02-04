class AddressRequestExpiration < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :address_request_id, :duration_hit_hours, :duration_limit_hours
end
