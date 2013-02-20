class User < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited

  has_one_audited :user_profile
  has_one_audited :api_key
  has_one_audited :facebook_token
  has_one_audited :stripe_customer
  has_one_audited :recipient_address, foreign_key: "recipient_user_id"

  has_many :sent_address_requests, foreign_key: "request_sender_user_id", class_name: "AddressRequest", order: "created_at desc"
  has_many :received_address_requests, foreign_key: "request_recipient_user_id", class_name: "AddressRequest", order: "created_at desc"
  has_many :card_orders, foreign_key: "order_sender_user_id"
  has_many :authored_card_designs, foreign_key: "author_user_id", class_name: "CardDesign"
  has_many :card_printings, foreign_key: "recipient_user_id"
  has_many :authored_card_images, foreign_key: "author_user_id", class_name: "CardImage"

  def self.first_or_create_with_facebook_token(facebook_token, *args)
    options = args.extract_options!
    api = options[:api] || Koala::Facebook::API.new(facebook_token)
    facebook_token_record = FacebookToken.where(token: facebook_token).first

    begin
      profile = api.get_object("me?fields=name,first_name,middle_name,last_name,location,gender,email,birthday")
      facebook_id = profile["id"]

      user = User.where(facebook_id: facebook_id).first_or_create!

      location = nil
      location = profile["location"]["name"] if profile["location"]

      birthday = nil
      birthday = Chronic.parse(profile["birthday"] + " 00:00:00") if profile["birthday"]

      facebook_token_record = FacebookToken.where(user_id: user.user_id, token: facebook_token).first_or_create!

      user.tap do |user|
        UserProfile.where(user_id: user.user_id,
                          name: profile["name"],
                          first_name: profile["first_name"],
                          last_name: profile["last_name"],
                          location: location,
                          middle_name: profile["middle_name"],
                          birthday: birthday,
                          gender: profile["gender"],
                          email: profile["email"]).first_or_create!
      end
    rescue Koala::Facebook::AuthenticationError => e
      facebook_token_record.state = :expired if facebook_token_record

      # TODO log authentication error
      return nil
    end
  end

  def add_login!
    UserLogin.where(user_id: self.user_id, app_id: App.lulcards.app_id).create!
  end

  def renew_api_key!
    ApiKey.where(user_id: self.user_id).create!
  end

  def has_mailable_address?
    recipient_address.try(:mailable?)
  end

  def has_pending_address_request?
    received_address_requests.first.try(:pending?)
  end

  def requires_address_request?
    !has_mailable_address? && !has_pending_address_request?
  end

  def send_address_request!(*args)
    options = args.extract_options!

    self.sent_address_requests.create!(
      request_recipient_user: options[:recipient],
      app: options[:app],
      address_request_medium: options[:medium],
      address_request_payload: args[0],
    )
  end

  def payment_info_state
    return :none unless self.stripe_customer
    self.stripe_customer.payment_info_state
  end

  def set_stripe_payment_info_with_token(token)
    stripe_customer_name = "User"
    stripe_customer_name = "#{self.user_profile.last_name}, #{self.user_profile.first_name}" if self.user_profile
    stripe_customer_name += " ##{self.user_id}/#{self.facebook_id}"

    pending_customer = Stripe::Customer.create(description: stripe_customer_name, card: token)
    pending_customer.save

    if pending_customer.active_card && pending_customer.active_card["cvc_check"] == "fail"
      begin
        pending_customer.delete
      ensure
        raise StripeCvcCheckFailException.new
      end
    end

    self.stripe_customer.try(:delete_from_stripe!)
    self.stripe_customers.create!(stripe_id: pending_customer["id"])
    self.stripe_customer.stripe_card = StripeCard.find_or_create_by_stripe_card_info(pending_customer.active_card)
  end

  def remove_stripe_payment_info!
    return if self.payment_info_state == :none
    self.stripe_customer.try(:delete_from_stripe!)
    self.stripe_customer.stripe_card = nil
  end

  def create_order_from_payload!(payload, *args)
    ensure_order_payload_valid(payload, *args)
    app = App.by_name(payload["app"])

    image_types = %w(original_full_photo composed_full_photo edited_full_photo)

    image_ids = image_types.reduce({}) do |image_ids, image_type|
      image_ids.tap do |image_ids|
        card_image_params = payload["card_design"][image_type]

        if card_image_params
          card_image_params = card_image_params.merge(app: app, 
                                                      image_type: image_type.to_sym)

          card_image = CardImage.where(uuid: card_image_params["uuid"]).first
          card_image ||= self.authored_card_images.create!(card_image_params)
          image_ids["#{image_type}_image"] = card_image
        end
      end
    end

    card_design_args = payload["card_design"]
                        .except(*image_types)
                        .merge(design_type: :lulcards_alpha, app: app)
                        .merge(image_ids)

    card_design = self.authored_card_designs.create!(card_design_args)

    card_order = self.card_orders.create!(app: app,
                                          card_design: card_design,
                                          quoted_total_price: payload["quoted_total_price"])

    card_order.tap do |card_order|
      payload["recipients"].each do |recipient|
        recipient_user = User.where(facebook_id: recipient["facebook_id"]).first_or_create!
        card_order.card_printings.create!(recipient_user: recipient_user)

        if recipient_user.requires_address_request?
          address_request = self.send_address_request!({ message: recipient["address_request_message"] },
                                                         recipient: recipient_user,
                                                         app: app,
                                                         medium: :facebook_message)

          address_request.state = :sent if recipient["sent_address_request"]
        end
      end
    end
  end

  private 

  def ensure_order_payload_valid(payload, *args)
    errors = []
    options = args.extract_options!

    raise_order_exception = lambda do |error_type|
      raise OrderCreationException.new(error_type)
    end

    raise_order_exception.(:no_facebook_token) unless payload["facebook_token"]
    api = options[:api] || Koala::Facebook::API.new(payload["facebook_token"])

    raise_order_exception.(:no_app_specified) unless payload["app"]
    app = App.by_name(payload["app"])

    profile = api.get_object("me?fields=id")
    facebook_id = profile["id"]
    raise_order_exception.(:token_mismatch) unless self.facebook_id == facebook_id

    unless self.payment_info_state == :active
      raise_order_exception.("#{self.payment_info_state.to_s}_payment".to_sym)
    end

    raise_order_exception.(:no_recipients) unless payload["recipients"] && payload["recipients"].size > 0
    number_of_cards_to_send = payload["recipients"].size
    raise_order_exception.(:max_recipients_reached) if number_of_cards_to_send > CONFIG.max_cards_to_send

    friend_facebook_ids = Set.new(api.get_object("me/friends?fields=id").map { |obj| obj["id"] })
    recipient_facebook_ids = Set.new(payload["recipients"].map { |r| r["facebook_id"] })

    unless friend_facebook_ids.intersection(recipient_facebook_ids) == recipient_facebook_ids
      raise_order_exception.(:not_connected_to_recipients) 
    end

    payload["recipients"].each do |recipient|
      facebook_id = recipient["facebook_id"]
      granted = recipient["granted_address_request_permission"]
      sent = recipient["sent_address_request"]
      message = recipient["address_request_message"]

      recipient_user = User.where(facebook_id: facebook_id).first_or_create!

      if recipient_user.requires_address_request? 
        unless recipient["granted_address_request_permission"] || recipient["sent_address_request"]
          raise_order_exception.(:needs_recipient_address_requests)
        end

        raise_order_exception.(:missing_address_request_message) unless recipient["address_request_message"].kind_of?(String)
      end
    end

    total_price = CONFIG.processing_fee + (CONFIG.card_fee * number_of_cards_to_send)

    unless payload["quoted_total_price"] == total_price
      raise_order_exception.(:misquoted_total_price)
    end

    raise_order_exception.(:no_card_design) unless payload["card_design"]
  end
end

