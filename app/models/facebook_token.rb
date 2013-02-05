class FacebookToken < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  belongs_to :user

  has_audited_state_through :facebook_token_state
end
