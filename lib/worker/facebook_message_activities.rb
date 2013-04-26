class FacebookMessageActivities
  def verify_order_with_facebook_token(card_order_id, facebook_token)
    card_order = CardOrder.find(card_order_id)
    sender = card_order.order_sender_user
    recipients = card_order.card_printings.map(&:recipient_user)
    verify_sender_recipients(sender, recipients)
  end

  def verify_birthday_requests(birthday_request_ids)
    return "verified" unless birthday_request_ids.size > 0

    birthday_requests = BirthdayRequest.find(birthday_request_ids)
    sender = birthday_requests[0].request_sender_user
    recipients = birthday_requests.map(&:request_recipient_user)
    verify_sender_recipients(sender, recipients)
  end

  def verify_sender_recipients(sender, recipients)
    facebook_token = sender.facebook_token.token
    api = Koala::Facebook::API.new(facebook_token)
    profile = api.get_object("me?fields=id")

    unless sender.facebook_id == profile["id"]
      return "not_verified"
    end

    #friend_facebook_ids = Set.new(api.get_object("me/friends?fields=id").map { |obj| obj["id"] })

    #allowed_recipient_facebook_ids = friend_facebook_ids + Set.new([sender.facebook_id])
    recipient_facebook_ids = Set.new(recipients.map(&:facebook_id))

    #unless allowed_recipient_facebook_ids.intersection(recipient_facebook_ids) == recipient_facebook_ids
    #  return "not_verified"
    #end

    recipient_facebook_ids.each do |recipient_facebook_id|
      recipient_facebook_response = api.get_object("#{recipient_facebook_id}?fields=#{UserProfile::FACEBOOK_FIELDS.join(",")}")
      User.first_or_update_with_facebook_response(recipient_facebook_response)
    end

    return "verified"
  end

  def send_message_for_address_request(address_request_id)
    address_request = AddressRequest.find(address_request_id)
    address_request.send!
    true
  end

  def check_for_address_request_progress(address_request_id)
    address_request = AddressRequest.find(address_request_id)

    address_request.request_recipient_user.received_address_requests.each do |request|
      request.close_if_address_supplied!
    end

    address_request.reload

    return "has_address" if address_request.request_recipient_user.has_up_to_date_address?
    return "has_message" if address_request.has_new_facebook_thread_activity?
    return "expired" if address_request.expired?
    return "no_progress"
  end

  def send_message_for_birthday_request(birthday_request_id)
    birthday_request = BirthdayRequest.find(birthday_request_id)
    birthday_request.send!
    true
  end

  def check_for_birthday_request_progress(birthday_request_id)
    birthday_request = BirthdayRequest.find(birthday_request_id)

    return "has_birthday" if birthday_request.request_recipient_user.has_birthday?
    return "has_message" if birthday_request.has_new_facebook_thread_activity?
    return "expired" if birthday_request.expired?
    return "no_progress"
  end

  def share_card_order_object
#fb:explicitly_shared=true
#  image[0][url]=http://www.yourdomain.com/images/my_camera_pizza_pic.jpg&
#    image[0][user_generated]=true&
#    https://graph.facebook.com/me/lulcards:mail?
#    access_token=ACCESS_TOKEN&
#    method=POST&
#    card=http://samples.ogp.me/535056913204674
  end
end
