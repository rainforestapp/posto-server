class AddressApiResponse < ActiveRecord::Base
  include AppendOnlyModel

  has_many :recipient_addresses

  serialize :arguments, ActiveRecord::Coders::Hstore
  serialize :response, ActiveRecord::Coders::Hstore
end
