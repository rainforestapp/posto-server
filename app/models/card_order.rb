class CardOrder < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :app, :quoted_total_price, :card_design

  belongs_to :order_sender_user, class_name: "User"
  belongs_to :app
  belongs_to :card_design

  has_many :card_printings
  has_many :transactions, order: "created_at desc"

  has_audited_state_through :card_order_state

  def mark_as_cancelled!
    self.card_printings.each(&:mark_as_cancelled!)
    self.state = :cancelled
  end

  def mark_as_finished!
    self.state = :finished
  end

  def mailable_card_printings
    self.card_printings.select(&:mailable?)
  end

  def self.total_price_to_charge_for_number_of_cards(number_of_cards)
    CONFIG.processing_fee + (CONFIG.card_fee * number_of_cards)
  end

  def total_price_to_charge
    number_of_cards = self.mailable_card_printings.size
    CardOrder.total_price_to_charge_for_number_of_cards(self.mailable_card_printings.size)
  end

  def order_number
    10000 + (self.card_order_id * 17)
  end

  def send_order_notification(message)
    device_alias = "#{app.name}-#{Rails.env}-user-#{order_sender_user_id}"
    Urbanairship.push({ schedule_for: [Time.zone.now], 
                        aliases: [device_alias], 
                        aps: { alert: message }})
  end
end
