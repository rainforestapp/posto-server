class StripeCustomer < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited

  attr_accessible :stripe_id

  has_one_audited :stripe_customer_card
  belongs_to_and_marks_latest_within :user
  after_save :invalidate_payment_info_state!

  def has_active_card?
    self.payment_info_state == :active
  end

  def payment_info_state
    return :none unless self.stripe_customer_card
    return :active if self.stripe_customer_card.try(:active?)
    return :declined if self.stripe_customer_card.try(:declined?)
    return :expired if self.stripe_card.try(:expired?)
    :none
  end

  def stripe_card
    return nil unless self.stripe_customer_card
    return nil if self.stripe_customer_card.state == :removed
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

  def delete_from_stripe!
    Stripe::Customer.retrieve(self.stripe_id).delete
  end

  def invalidate_payment_info_state!
    user.invalidate_payment_info_state!
  end
end
