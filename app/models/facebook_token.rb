class FacebookToken < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :token, :user_id

  belongs_to :user

  has_audited_state_through :facebook_token_state

  after_create do
    Rails.cache.delete(FacebookToken.current_facebook_token_cache_key_for_user_id(self.user_id))
  end

  def self.current_facebook_token_for_user_id(user_id)
    Rails.cache.fetch(current_facebook_token_cache_key_for_user_id(user_id)) do
      User.find(user_id).facebook_token.token
    end
  end

  def self.current_facebook_token_cache_key_for_user_id(user_id)
    [:current_facebook_token, user_id]
  end
end
