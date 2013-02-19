require 'spec_helper'

describe ModelQueryActivities do
  it "should get outgoing and sent requests for card order" do
    worker = ModelQueryActivities.new
    card_order = create(:card_order_with_prints)
    recip = card_order.card_printings[0].recipient_user
    order_id = card_order.card_order_id

    request = card_order.order_sender_user.send_address_request!({
      message: "hello",
      recipient: recip,
      app: create(:app),
      medium: :facebook_message,
    })

    worker.get_outgoing_request_ids_for_card_order(order_id).should == [request.address_request_id]
    worker.get_sent_request_ids_for_card_order(order_id).should == []

    request.state = :sent

    worker.get_outgoing_request_ids_for_card_order(order_id).should == []
    worker.get_sent_request_ids_for_card_order(order_id).should == [request.address_request_id]
  end

  it "should get printable cards" do
  end
end
