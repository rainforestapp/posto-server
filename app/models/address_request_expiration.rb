class AddressRequestExpiration < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :duration_hit_hours, :duration_limit_hours

  belongs_to :address_request
end
