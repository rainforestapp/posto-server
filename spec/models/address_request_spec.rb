require 'spec_helper'

describe AddressRequest do
  it "should start out pending" do
    request = create(:address_request)
    request.state.should == :pending
    request.address_responses.should be_empty
    request.address_request_expiration.should be_nil
    request.address_request_polling.should be_nil
  end

  it "should not expire unexpirable address requests" do
    request = create(:address_request)
    request.should_not be_expirable
  end

  it "should be markable as expired" do
    request = create(:expirable_address_request)
    request.check_and_expire!
    request.state.should == :expired
    request.address_request_expiration.should_not be_nil
    request.address_request_expiration.duration_hit_hours.should == 100 * 24
    request.address_request_expiration.duration_limit_hours.should == CONFIG.address_request_expiration_days * 24
    request.should_not be_expirable
  end

  it "should be markable as failed" do
    request = create(:address_request)
    request.mark_as_failed!(errors: "Foo")
    request.state.should == :failed
    request.meta["errors"].should == "Foo"
  end
end
