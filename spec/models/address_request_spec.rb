require 'spec_helper'

describe AddressRequest do
  it "should start out pending" do
    request = create(:address_request)
    request.state.should == :outgoing
    request.mark_as_sent!
    request.state.should == :sent
  end

  it "should not expire unexpirable address requests" do
    request = create(:address_request)
    request.should_not be_expirable
  end

  it "should be markable as expired" do
    request = create(:expirable_address_request)
    request.check_and_expire!
    request.state.should == :expired
    request.should_not be_expirable
  end

  it "should be markable as failed" do
    request = create(:address_request)
    request.mark_as_failed!(errors: "Foo")
    request.state.should == :failed
    request.meta[:errors].should == "Foo"
  end

  it "should post api response into address request and mark as closed" do
    api_response = create(:address_api_response)
    request = create(:address_request)
    recipient = request.request_recipient_user
    recipient.recipient_address.should be_nil
    recipient.should have_pending_address_request
    recipient.should_not have_mailable_address

    request.close_with_api_response(api_response)
    recipient.recipient_address.address_api_response.should == api_response
    recipient.recipient_address.address_request.should == request
    recipient.should_not have_pending_address_request
    recipient.should have_mailable_address
    request.state.should == :closed
  end

  it "should not allow a new request to be made if one already exists" do
    sender = create(:user)
    recipient = create(:user)
    app = create(:app)
    recipient.should_not have_pending_address_request

    request = sender.send_address_request!({ message: "foo" }, 
                                             recipient: recipient, 
                                             app: app, 
                                             medium: :facebook_message)

    recipient.should have_pending_address_request
    request.app.should == app
    request.request_recipient_user.should == recipient
    request.address_request_medium.should == :facebook_message
    request.address_request_payload[:message].should == "foo"

    expect {
      sender.send_address_request!({ message: "foo" }, 
                                     recipient: recipient, 
                                     app: app, 
                                     medium: :facebook_message)
    }.to raise_error("Pending address request already exists for #{recipient}")
  end
end
