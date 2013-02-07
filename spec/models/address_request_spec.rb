require 'spec_helper'

describe AddressRequest do
  it "should start out pending" do
    request = create(:address_request)
    request.state.should == :outgoing
    request.address_responses.should be_empty
    request.address_request_expiration.should be_nil
    request.address_request_polling.should be_nil
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

  it "should add response" do
    request = create(:address_request)
    request.add_response("123123", :facebook_message, { "message" => "foo" })
    request.address_responses.reload.size.should == 1
    request.address_responses[0].response_data["message"].should == "foo"
    request.address_responses[0].response_source_id.should == "123123"
    request.address_responses[0].response_source_type.should == :facebook_message
    request.address_responses[0].response_sender_user.should == request.request_recipient_user
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

    request = sender.send_address_request({ message: "foo" }, 
                                            recipient: recipient, 
                                            app: app, 
                                            medium: :facebook_message)

    recipient.should have_pending_address_request
    request.app.should == app
    request.request_recipient_user.should == recipient
    request.address_request_medium.should == :facebook_message
    request.address_request_payload["message"].should == "foo"

    expect {
      sender.send_address_request({ message: "foo" }, 
                                              recipient: recipient, 
                                              app: app, 
                                              medium: :facebook_message)
    }.to raise_error("Pending address request already exists for #{recipient}")
  end
end
