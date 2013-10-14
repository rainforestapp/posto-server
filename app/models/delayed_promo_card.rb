class DelayedPromoCard < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited
  include TransactionRetryable

  attr_accessible :user_id, :supplied_address_api_response_id

  belongs_to :user
  belongs_to :supplied_address_api_response, class_name: "AddressApiResponse"

  has_audited_state_through :delayed_promo_card_state
end
