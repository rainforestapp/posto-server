class FacebookMessageActivities
  def verify_order_with_facebook_token(card_order_id, facebook_token)
    api = Koala::Facebook::API.new(facebook_token)
    card_order = CardOrder.find(card_order_id)
    recipients = card_order.card_printings.map(&:recipient_user)
    sender = card_order.order_sender_user
    profile = api.get_object("me?fields=id")

    unless sender.facebook_id == profile["id"]
      return "not_verified"
    end

    friend_facebook_ids = Set.new(api.get_object("me/friends?fields=id").map { |obj| obj["id"] })
    recipient_facebook_ids = Set.new(recipients.map(&:facebook_id))

    unless friend_facebook_ids.intersection(recipient_facebook_ids) == recipient_facebook_ids
      return "not_verified"
    end

    "verified"
  end

  def send_message_for_address_request(address_request_id)
    puts "fb send #{address_request_id}"
  end

  def check_for_address_request_progress(address_request_id)
    puts "check fb progress #{address_request_id}"
    # return "has_message", "has_address", "no_progress"
    "has_message"
  end
end
