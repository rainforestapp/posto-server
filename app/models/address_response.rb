class AddressResponse < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :response_source_id, :response_source_type, :response_sender_user, :response_data

  belongs_to :address_request
  belongs_to :response_sender_user, class_name: "User"
  symbolize :response_source_type, in: [:facebook_message], validate: true

  serialize :response_data, Hash
end
