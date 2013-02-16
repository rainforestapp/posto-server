class AddressApiResponse < ActiveRecord::Base
  include AppendOnlyModel

  has_many :recipient_addresses

  serialize :arguments, JSON
  serialize :response, JSON
end
