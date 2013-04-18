class BirthdayRequest < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState
  include RecipientRequest

  attr_accessible :request_recipient_user, :app, :birthday_request_medium, :birthday_request_payload, :state

  belongs_to :request_sender_user, class_name: "User"
  belongs_to :request_recipient_user, class_name: "User"
  belongs_to :app
  has_one :birthday_request_response

  has_audited_state_through :birthday_request_state

  symbolize :birthday_request_medium, in: [:facebook_message], validate: true
  serialize :birthday_request_payload, Hash

  has_one_audited :birthday_request_facebook_thread

  def expiration_days
    CONFIG.for_app(self.app).birthday_request_expiration_days.days
  end

  def payload
    self.birthday_request_payload
  end

  def facebook_thread
    self.birthday_request_facebook_thread
  end

  def facebook_threads
    self.birthday_request_facebook_threads
  end
end
