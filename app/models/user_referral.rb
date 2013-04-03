class UserReferral < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState

  belongs_to :referred_user, class_name: "User"
  belongs_to :referring_user, class_name: "User"
  belongs_to :app

  attr_accessible :referred_user_id, :referring_user_id, :app_id

  has_audited_state_through :user_referral_state
end
