class RecipientAddress < ActiveRecord::Base
  include AppendOnlyModel
  
  belongs_to_and_marks_latest_within :recipient_user, :class_name => "User"
  belongs_to :address_api_response

  def expired?
    Time.zone.now > expires_at
  end

  def mailable?
    !expired?
  end

  def expires_at
    self.created_at + CONFIG.recipient_address_expiration_days.days
  end
end
