class CardPrinting < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited
  include HasUid

  attr_accessible :recipient_user

  belongs_to :card_order
  belongs_to :recipient_user, class_name: "User"
  has_one_audited :card_printing_composition

  has_one_audited :card_scan
  has_many :card_scans

  before_save(on: :create) do
    self.print_number = self.class.connection.select_value <<-END
      select coalesce(max(print_number), 0) + 1 from card_printings
    END
  end

  has_audited_state_through :card_printing_state

  def card_design
    card_order.card_design
  end

  def mailable?
    self.recipient_user.mailable?
  end

  def front_scan_key
    "f" + self.uid
  end

  def back_scan_key
    "b" + self.uid
  end

  def mark_as_cancelled!
    self.state = :cancelled
  end

  def card_number
    (800000000 + (self.card_printing_id * 13)).to_s
  end

  def name_or_self(self_text)
    return self_text if self.recipient_user == self.card_order.order_sender_user
    self.recipient_user.user_profile.try(:name)
  end

  def should_draw_credits_nag?
    return true if card_order.is_promo
    return true if self.recipient_user != self.card_order.order_sender_user
    return true if self.recipient_user == self.card_order.order_sender_user &&
                   self.card_order.order_sender_user.credit_plan_id_for_app(card_order.app) == nil &&
                   self.card_order.order_sender_user.credits_for_app(card_order.app) == 0

    return false
  end

  def lookup_number
    (self.card_printing_id * 13) + 17
  end

  def self.find_by_lookup_number(lookup_number)
    lookup_number = (lookup_number.to_f - 17.0) / 13.0

    return nil if lookup_number % 1.0 > 0.01

    CardPrinting.where(card_printing_id: lookup_number.to_i).first
  end
end

