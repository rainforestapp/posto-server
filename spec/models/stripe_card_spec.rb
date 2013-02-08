require 'spec_helper'

describe StripeCard do
  it "should consider card expired" do
    card = create(:stripe_card)
    card.should_not be_expired
    expired_card = create(:expired_stripe_card)
    expired_card.should be_expired
  end

  it "should assign stripe card to customer and mark as defunct" do
    customer = create(:stripe_customer)
    customer.stripe_card.should be_nil
    customer.should_not have_active_card
    customer.user.should_not have_active_stripe_card

    card = create(:stripe_card)
    customer.stripe_card = card
    customer.stripe_card.should == card
    customer.should have_active_card
    customer.user.should have_active_stripe_card

    customer.stripe_card = nil
    customer.stripe_card.should be_nil
    customer.should_not have_active_card
    customer.user.should_not have_active_stripe_card
  end
end
