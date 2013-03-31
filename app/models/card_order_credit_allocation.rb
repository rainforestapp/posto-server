class CardOrderCreditAllocation < ActiveRecord::Base
  include AppendOnlyModel

  belongs_to_and_marks_latest_within :card_order

  attr_accessible :credits_per_card, :credits_per_order, :number_of_credited_cards

  before_save on: :create do
    self.credits_per_card = CONFIG.card_credits
    self.credits_per_order = CONFIG.processing_credits
  end

  def allocated_credits
    self.credits_per_order + (self.credits_per_card * self.number_of_credited_cards)
  end
end
