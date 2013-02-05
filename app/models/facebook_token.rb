class FacebookToken < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState

  belongs_to :user

  has_audited_state_through :facebook_token_state
end
