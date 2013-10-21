class CreditPromo < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState
  include HasUid

  attr_accessible :credits, :granted_to_user_id, :app_id, :intended_recipient_user_id, :credit_promo_type

  symbolize :credit_promo_type, in: [:ad_hoc, :birthday_reminder], validates: true

  belongs_to :granted_to_user, class_name: "User"
  belongs_to :intended_recipient_user, class_name: "User"
  belongs_to :app

  has_audited_state_through :credit_promo_state

  def grant_to!(user)
    return false unless self.state == :pending
    return false if self.intended_recipient_user_id && self.intended_recipient_user_id != user.user_id

    self.granted_to_user_id = user.user_id
    self.redeemed_at = Time.now
    self.save!
    self.state = :granted

    user.add_credits!(self.credits, app: app, source_type: :promo, source_id: self.credit_promo_id)

    return true
  end
end
