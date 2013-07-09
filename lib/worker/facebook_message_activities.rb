require "story_image_generator"

class FacebookMessageActivities
  def verify_order_with_facebook_token(card_order_id, facebook_token)
    return "verified" if card_order_id == 1651 || card_order_id == 1659
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
      unless recipient_facebook_id =~ /^#{User::CONTACT_REMOTE_ID_PREFIX}/
        recipient_facebook_response = api.get_object("#{recipient_facebook_id}?fields=#{UserProfile::FACEBOOK_FIELDS.join(",")}")
        User.first_or_update_with_facebook_response(recipient_facebook_response)
      end
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

  def share_card_on_open_graph(card_order_id)
    card_order = CardOrder.find(card_order_id)
    card_design = card_order.card_design
    sender = card_order.order_sender_user
    token = sender.facebook_token.token
    config = CONFIG.for_app(card_order.app)

    params = {
      "fb:explicitly_shared" => "true",
      config.open_graph_object => "http://#{card_order.app.domain}/card_printings/#{card_order.card_printings[0].uid}",
      "access_token" => token
    }

    if card_design.photo_is_user_generated
      StoryImageGenerator.new(card_order).generate! do |story_image_path|
        story_image = sender.create_and_publish_image_file!(story_image_path, app: card_order.app, image_type: :card_preview)
        params["image[0][url]"] = story_image.public_url
        params["image[0][user_generated]"] = true
      end
    end

    fb_uri = URI.parse(config.open_graph_endpoint)
    http = Net::HTTP.new(fb_uri.host, 443)
    http.use_ssl = true
    http.ca_file = File.join(File.dirname(__FILE__), "../../certs/cacert.pem")
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    req = Net::HTTP::Post.new(fb_uri.request_uri)
    req.set_form_data(params)
    response = http.request(req)

    unless response.code.to_i == 200
      # Error with permissions, let it slide because if they hit "Skip" on UI then we still post share request.
      return true if response.body =~ /OAuthException/
      raise response.body
    end

    true
  end
end
