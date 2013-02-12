class AddressRequest < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState

  attr_accessible :request_recipient_user, :app, :address_request_medium, :address_request_payload

  belongs_to :request_sender_user, class_name: "User"
  belongs_to :request_recipient_user, class_name: "User"
  belongs_to :app

  has_many :address_responses

  has_audited_state_through :address_request_state
  has_one_audited :address_request_expiration
  has_one_audited :address_request_polling

  symbolize :address_request_medium, in: [:facebook_message], validate: true
  serialize :address_request_payload, ActiveRecord::Coders::Hstore

  before_create :ensure_no_other_pending_request_for_recipient

  def expirable?
    return false unless self.pending?

    Time.zone.now > self.created_at + CONFIG.address_request_expiration_days.days
  end

  def pending?
    [:outgoing, :sent].include?(self.state)
  end

  def check_and_expire!
    return false unless expirable?

    duration_hit_hours = ((Time.zone.now - self.created_at) / (60 * 60)).floor

    self.address_request_expirations.create!(
      duration_hit_hours: duration_hit_hours,
      duration_limit_hours: CONFIG.address_request_expiration_days * 24
    )

    self.state = :expired
  end

  def mark_as_sent!
    self.state = :sent
  end

  def mark_as_failed!(*args)
    metadata = args.extract_options!
    self.append_to_metadata!(metadata) if metadata
    self.state = :failed
  end

  def add_response(response_source_id, response_source_type, response_data)
    address_responses.create!(response_source_id: response_source_id, 
                              response_source_type: response_source_type,
                              response_sender_user: request_recipient_user,
                              response_data: response_data)
  end

  def close_with_api_response(address_api_response)
    self.request_recipient_user.recipient_addresses.create!(
      address_api_response: address_api_response,
      address_request: self
    )

    self.state = :closed
  end

  def ensure_no_other_pending_request_for_recipient
    if self.request_recipient_user.has_pending_address_request?
      raise "Pending address request already exists for #{self.request_recipient_user}"
    end
  end
end
