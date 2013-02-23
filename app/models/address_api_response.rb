require "open-uri"

class AddressApiResponse < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :arguments, :response, :api_type

  has_many :recipient_addresses

  serialize :arguments, Hash
  serialize :response, Hash

  symbolize :api_type, in: [:live_address], validates: true

  RECORD_EXPIRATION = 90.days

  def self.lookup(query)
    arguments = { street: query }
    record = self.where(arguments: YAML.dump(arguments)).first
    return record if record && record.created_at > Time.zone.now - RECORD_EXPIRATION

    url_params = arguments.merge("auth-token" => ENV["LIVEADDRESS_AUTH_TOKEN"],
                                 "auth-id" => ENV["LIVEADDRESS_AUTH_ID"],
                                 "candidates" => 1)

    url = "https://api.smartystreets.com/street-address?#{url_params.to_param}"

    open(url) do |data|
      result = JSON.parse(data.read)
      response = (result[0] || {})
      AddressApiResponse.create!(arguments: arguments, response: response, api_type: :live_address)
    end
  end
end
