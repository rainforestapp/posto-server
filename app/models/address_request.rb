class AddressRequest < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState
  include RecipientRequest

  attr_accessible :request_recipient_user, :app, :address_request_medium, :address_request_payload, :state,
                  :sender_supplied_address_api_response

  belongs_to :request_sender_user, class_name: "User"
  belongs_to :request_recipient_user, class_name: "User"
  belongs_to :app
  belongs_to :sender_supplied_address_api_response, class_name: "AddressApiResponse"

  has_audited_state_through :address_request_state

  symbolize :address_request_medium, in: [:facebook_message], validate: true
  serialize :address_request_payload, Hash

  has_one_audited :address_request_facebook_thread

  def expiration_days
    CONFIG.for_app(self.app).address_request_expiration_days.days
  end

  def payload
    self.address_request_payload
  end

  def facebook_thread
    self.address_request_facebook_thread
  end

  def facebook_threads
    self.address_request_facebook_threads
  end

  def has_supplied_address?
    !!self.sender_supplied_address_api_response
  end

  def mark_as_supplied_with_address_api_response!(address_api_response)
    self.sender_supplied_address_api_response = address_api_response
    self.save!

    self.state = :supplied
  end

  def close_with_api_response(address_api_response)
    self.request_recipient_user.recipient_addresses.create!(
      address_api_response: address_api_response,
      address_request: self
    )

    self.request_recipient_user.received_address_requests.each do |request|
      request.mark_as_closed!
    end
  end

  def close_if_address_supplied!
    if has_supplied_address?
      self.close_with_api_response(self.sender_supplied_address_api_response)
    end
  end
end
