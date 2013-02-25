class CardOrder < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :app, :quoted_total_price, :card_design

  belongs_to :order_sender_user, class_name: "User"
  belongs_to :app
  belongs_to :card_design

  has_many :card_printings

  has_audited_state_through :card_order_state

  def mark_as_failed!
    self.card_printings.each(&:mark_as_failed!)
    self.state = :failed
  end

  def mark_as_finished!
    self.state = :finished
  end

  def mailable_card_printings
    self.card_printings.select(&:printable?)
  end

  def total_price_to_charge
    number_of_cards = self.mailable_card_printings.size
    CONFIG.processing_fee + (CONFIG.card_fee * number_of_cards)
  end
end
