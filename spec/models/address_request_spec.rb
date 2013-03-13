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
    recipient.should_not be_mailable

    request.close_with_api_response(api_response)
    recipient.recipient_address.address_api_response.should == api_response
    recipient.recipient_address.address_request.should == request
    recipient.should_not have_pending_address_request
    recipient.should be_mailable
    request.state.should == :closed
  end

  it "should allow a new request to be made if one already exists if address is supplied" do
    sender = create(:user)
    recipient = create(:user)
    app = create(:app)
    api_response = create(:address_api_response)

    recipient.should_not have_pending_address_request

    request = sender.enqueue_address_request!({ message: "foo" }, 
                                                recipient: recipient, 
                                                app: app, 
                                                medium: :facebook_message)

    recipient.should have_pending_address_request
    request.app.should == app
    request.request_recipient_user.should == recipient
    request.address_request_medium.should == :facebook_message
    request.address_request_payload[:message].should == "foo"

    supplied_request = sender.enqueue_address_request!({ message: "foo" }, 
                                                         recipient: recipient, 
                                                         app: app, 
                                                         medium: :facebook_message)

    supplied_request.mark_as_supplied_with_address_api_response!(api_response)

    recipient.should have_pending_address_request

    supplied_request.close_if_address_supplied!

    recipient.should_not have_pending_address_request
    recipient.requires_address_request?.should be_false
  end
end
