class CardOrder < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :app, :quoted_total_price

  belongs_to :order_sender_user, class_name: "User"
  belongs_to :app
  has_many :card_printings

  has_audited_state_through :card_order_state
end
