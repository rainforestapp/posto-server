class CardPrinting < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :recipient_user

  belongs_to :card_order
  belongs_to :recipient_user, class_name: "User"
  has_one_audited :card_printing_composition

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
    "f" + Base64.encode64(self.card_printing_id.to_s).chomp
  end

  def back_scan_key
    "b" + Base64.encode64(self.card_printing_id.to_s).chomp
  end

  def mark_as_cancelled!
    self.state = :cancelled
  end
end
