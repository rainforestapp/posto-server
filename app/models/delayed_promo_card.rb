class DelayedPromoCard < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited
  include TransactionRetryable

  attr_accessible :user_id, :supplied_address_api_response_id

  belongs_to :user
  belongs_to :supplied_address_api_response, class_name: "AddressApiResponse"

  has_audited_state_through :delayed_promo_card_state

  def try_processing!
    return unless self.state == :pending

    promo_card_order = nil

    User.transaction_with_retry do
      card_order_to_use = nil

      # Find a card order to turn into a promo
      user.card_orders.each do |card_order|
        next if card_order.is_promo
        next if card_order.card_printings.map(&:recipient_user).include?(user)
        next if card_order_to_use && card_order_to_use.created_at > card_order.created_at

        card_order_to_use = card_order
      end

      return false unless card_order_to_use

      promo_card_order = card_order_to_use.to_promo_card_order_with_address_api_response(self.supplied_address_api_response)
    end

    if promo_card_order
      promo_card_order.execute_workflow!
      self.state = :processed
    end
  end
end
