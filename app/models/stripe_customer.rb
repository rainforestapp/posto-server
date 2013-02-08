class StripeCustomer < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited

  has_one_audited :stripe_customer_card
  belongs_to_and_marks_latest_within :user

  def has_active_card?
    self.stripe_card.try(:active?)
  end

  def stripe_card
    return nil unless self.stripe_customer_card.try(:state) == :active
    self.stripe_customer_card.stripe_card
  end

  def stripe_card=(stripe_card)
    return if self.stripe_card == stripe_card

    if stripe_card.nil?
      self.stripe_customer_card.try(:mark_as_removed!)
    else
      self.stripe_customer_cards.create!(:stripe_card => stripe_card)
    end
  end
end
