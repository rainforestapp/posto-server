require 'spec_helper'

describe CreditPlanMembership do
  it "should generate payments" do
    user = create(:greg_user)
    app = create(:app)

    membership = user.credit_plan_memberships.create!({
      app_id: app.app_id,
      credit_plan_price: 999,
      credit_plan_credits: 100,
      credit_plan_id: 123
    })

    CreditPlanMembership.find_memberships_without_payments.should include(membership)
    membership.state.should == :active

    membership.generate_payments!
    membership.credit_plan_payments.size.should == 12 * 5

    membership.generate_payments!
    membership.credit_plan_payments.size.should == 12 * 5

    due_payments = CreditPlanPayment.find_due_payments(on: Time.now + 3.month, since: 3.months)

    size_before_first_payment = due_payments.size
    due_payments.size.should be > 1
    due_payments.size.should be < 5

    due_payments.first.mark_as_paid!
    due_payments = CreditPlanPayment.find_due_payments(on: Time.now + 3.month, since: 3.months)
    due_payments.size.should == size_before_first_payment - 1

    membership.cancel!
    due_payments = CreditPlanPayment.find_due_payments(on: Time.now + 3.month, since: 3.months)
    due_payments.should be_empty
  end
end
