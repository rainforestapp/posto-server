class CardOrderCreditAllocation < ActiveRecord::Base
  include AppendOnlyModel

  belongs_to_and_marks_latest_within :card_order

  attr_accessible :credits_per_card, :credits_per_order, :number_of_credited_cards

  def allocated_credits
    return 0 if self.number_of_credited_cards == 0
    self.credits_per_order + (self.credits_per_card * self.number_of_credited_cards)
  end
end
