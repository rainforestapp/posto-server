require 'spec_helper'

describe StripeCard do
  it "should handle expired card" do
    customer = create(:stripe_customer)
    card = create(:stripe_card)
    card.should_not be_expired
    expired_card = create(:expired_stripe_card)
    expired_card.should be_expired

    customer.user.payment_info_state.should == :none
    customer.stripe_card = expired_card
    customer.user.payment_info_state.should == :expired
  end

  it "should assign stripe card to customer and mark as declined ok" do
    customer = create(:stripe_customer)
    user = customer.user
    customer.stripe_card.should be_nil
    customer.should_not have_active_card
    user.payment_info_state.should == :none

    card = create(:stripe_card)
    customer.stripe_card = card
    customer.stripe_card.should == card
    customer.should have_active_card
    user.payment_info_state.should == :active

    customer.stripe_customer_card.mark_as_declined!
    customer.should_not have_active_card
    customer.stripe_card.should_not be_nil
    user.payment_info_state.should == :declined

    customer.stripe_card = nil
    customer.stripe_card.should be_nil
    customer.should_not have_active_card
    user.payment_info_state.should == :none
  end

  it "should associate user with token and create customer" do
    user = create(:user)
    token = Stripe::Token.create(
      card: {
        number: "4242424242424242",
        exp_month: 5,
        exp_year: 2020,
        cvc: 123
      }
    )

    user.set_stripe_payment_info_with_token(token["id"])
    user.stripe_customer.should_not be_nil
    user.payment_info_state.should == :active

    stripe_card = user.stripe_customer.stripe_card
    stripe_card.card_type.should == :visa
    stripe_card.exp_month.should == 5
    stripe_card.exp_year.should == 2020
    stripe_card.last4.should == "4242"

    token = Stripe::Token.create(
      card: {
        number: "4242424242424242",
        exp_month: 5,
        exp_year: 2020,
        cvc: 123
      }
    )

    user.set_stripe_payment_info_with_token(token["id"])
    user.stripe_customer.stripe_card.should == stripe_card
    user.payment_info_state.should == :active

    user.remove_stripe_payment_info!
    user.payment_info_state.should == :none

    # remove customer from stripe so we don't clog the tubes
    Stripe::Customer.retrieve(user.stripe_customer.stripe_id).deleted.should be_true
  end

  it "should raise on cvc error" do
    user = create(:user)
    token = Stripe::Token.create(
      card: {
        number: "4000000000000101",
        exp_month: 5,
        exp_year: 2020,
        cvc: 123
      }
    )

    expect {
      user.set_stripe_payment_info_with_token(token["id"])
    }.to raise_error(StripeCvcCheckFailException)

    user.stripe_customer.should be_nil
    user.payment_info_state.should == :none
  end
end
