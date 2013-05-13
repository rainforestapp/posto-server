class CreditPromo < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState
  include HasUid
 
  attr_accessible :credits, :granted_to_user_id, :app_id

  belongs_to :granted_to_user, class_name: "User"
  belongs_to :app

  has_audited_state_through :credit_promo_state
end
