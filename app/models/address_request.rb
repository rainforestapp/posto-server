class AddressRequest < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState

  belongs_to :request_sender_user, class_name: "User"
  belongs_to :request_recipient_user, class_name: "User"
  belongs_to :app

  has_many :address_responses

  has_audited_state_through :address_request_state
  has_one_audited :address_request_expiration
  has_one_audited :address_request_polling

  symbolize :address_request_medium, in: [:facebook_message], validate: true
  serialize :address_request_payload, ActiveRecord::Coders::Hstore

  def expirable?
    return false unless [:pending, :sent].include?(self.state)

    Time.zone.now > self.created_at + CONFIG.address_request_expiration_days.days
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

  def mark_as_failed!(*args)
    metadata = args.extract_options!
    self.append_to_metadata!(metadata) if metadata
    self.state = :failed
  end
end
