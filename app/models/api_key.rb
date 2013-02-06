class ApiKey < ActiveRecord::Base
  include AppendOnlyModel

  belongs_to_and_marks_latest_within :user

  before_create :create_token
  before_create :initialize_expiration

  def create_token
    self.token = SecureRandom.hex
  end

  def initialize_expiration
    self.expires_at ||= DateTime.current + CONFIG.api_key_expiration_days.days
  end

  def expired?
    Time.zone.now > self.expires_at
  end

  def renewable?
    self.expired? || Time.zone.now > self.expires_at - CONFIG.api_key_renewal_days
  end

  def active?
    self.user.api_key == self
  end
end
