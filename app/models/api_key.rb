class ApiKey < ActiveRecord::Base
  include AppendOnlyModel

  #attr_accessible :token, :user_id
  belongs_to :user

  before_create :create_token
  before_create :initialize_expiration

  mark_latest_within_scope :user_id

  def create_token
    self.token = SecureRandom.hex
  end

  def initialize_expiration
    self.expires_at = DateTime.current + CONFIG[:api_key_expiration_days].days
  end

  def expired?
    Time.zone.now > self.expires_at
  end

  def renewable?
    self.expired? || Time.zone.now > self.expires_at - CONFIG[:api_key_renewal_days]
  end

  def active?
    self.user.api_key == self
  end
end
