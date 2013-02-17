class AddressApiResponse < ActiveRecord::Base
  include AppendOnlyModel

  has_many :recipient_addresses

  serialize :arguments, Hash
  serialize :response, Hash
end
