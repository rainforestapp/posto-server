class AddressResponse < ActiveRecord::Base
  include AppendOnlyModel

  belongs_to :address_request
  belongs_to :response_sender_user, class_name: "User"
  symbolize :response_source_type, in: [:facebook_message], validate: true

  serialize :response_data, ActiveRecord::Coders::Hstore
end
