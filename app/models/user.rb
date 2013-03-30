class User < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include TransactionRetryable

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
  has_many :aps_tokens, order: "aps_token_id desc"
  has_many :user_logins
  has_many :credit_orders
  has_many :credit_journal_entries

  def self.first_or_create_with_facebook_token(facebook_token, *args)
    options = args.extract_options!
    api = options[:api] || Koala::Facebook::API.new(facebook_token)
    facebook_token_record = FacebookToken.where(token: facebook_token).first

    begin
      profile = api.get_object("me?fields=#{UserProfile::FACEBOOK_FIELDS.join(",")}")

      first_or_update_with_facebook_response(profile).tap do |user|
        facebook_token_record = FacebookToken.where(user_id: user.user_id, token: facebook_token).lock(true).first_or_create!
      end
    rescue Koala::Facebook::AuthenticationError => e
      facebook_token_record.state = :expired if facebook_token_record

      # TODO log authentication error
      return nil
    end
  end

  def self.first_or_update_with_facebook_response(facebook_response)
    facebook_id = facebook_response["id"]

    user = User.where(facebook_id: facebook_id).lock(true).first_or_create!

    location = nil
    location = facebook_response["location"]["name"] if facebook_response["location"]

    birthday = nil
    birthday = Chronic.parse(facebook_response["birthday"] + " 00:00:00") if facebook_response["birthday"]

    user.tap do |user|
      new_fields = { user_id: user.user_id,
                     name: facebook_response["name"],
                     first_name: facebook_response["first_name"],
                     last_name: facebook_response["last_name"],
                     location: location,
                     middle_name: facebook_response["middle_name"],
                     birthday: birthday,
                     gender: facebook_response["gender"],
                     email: facebook_response["email"] }

      current_profile = user.user_profile

      if current_profile
        # Keep any existing non-nil fields
        current_fields = current_profile.attributes.symbolize_keys

        new_fields.keys.each do |k|
          new_fields[k] ||= current_fields[k]
        end
      end

      UserProfile.where(new_fields).first_or_create!
    end
  end

  def create_and_publish_image_file!(file_path, *args)
    options = args.extract_options!
    raise "Missing argument: app" unless options[:app]

    image = Magick::Image.read(file_path).first
    raise "No image found at #{file_path}" unless image

    begin
      card_image_params = {}
      card_image_params[:width] = image.columns
      card_image_params[:height] = image.rows
      card_image_params[:orientation] = :up
      card_image_params[:image_format] = CardImage::RMAGICK_IMAGE_FORMAT_MAP[image.format.downcase]
      card_image_params[:image_type] = options[:image_type]
      card_image_params[:app] = options[:app] 

      self.authored_card_images.create!(card_image_params).tap do |card_image|
        begin
          s3 = AWS::S3.new
          bucket = s3.buckets[CONFIG.card_image_bucket]
          s3_object = bucket.objects[card_image.path]
          s3_object.write(Pathname.new(file_path),
                          content_type: card_image.content_type,
                          acl: :public_read,
                          cache_control: "max-age=#{60 * 60 * 24 * 7}")
        rescue Exception => e
          # Kill it if we couldn't upload to s3
          card_image.destroy rescue nil
          raise
        end
      end
    ensure
      image.destroy!
    end
  end

  def add_login!
    UserLogin.where(user_id: self.user_id, app_id: App.lulcards.app_id).create!
  end

  def renew_api_key!
    ApiKey.where(user_id: self.user_id).create!
  end

  def mailable?
    !!recipient_address
  end

  def has_up_to_date_address?
    recipient_address.try(:up_to_date?)
  end

  def has_pending_address_request?
    received_address_requests.first.try(:pending?)
  end

  def requires_address_request?
    !has_up_to_date_address? && !has_pending_address_request?
  end

  def enqueue_address_request!(*args)
    options = args.extract_options!

    self.sent_address_requests.create!(
      request_recipient_user: options[:recipient],
      app: options[:app],
      address_request_medium: options[:medium],
      address_request_payload: args[0],
    )
  end

  def payment_info_state
    Rails.cache.fetch(payment_info_state_cache_key) do
      if self.stripe_customer
        self.stripe_customer.payment_info_state
      else
        :none
      end
    end
  end

  def set_stripe_payment_info_with_token(token)
    stripe_customer_name = "User"
    stripe_customer_name = "#{self.user_profile.last_name}, #{self.user_profile.first_name}" if self.user_profile
    stripe_customer_name += " ##{self.user_id}/#{self.facebook_id}"

    begin
      pending_customer = Stripe::Customer.create(description: stripe_customer_name, card: token)
      pending_customer.save

      if pending_customer.active_card && pending_customer.active_card["cvc_check"] == "fail"
        begin
          pending_customer.delete
        ensure
          raise StripeCvcCheckFailException.new
        end
      end
    rescue Stripe::CardError => e
      if e.message =~ /security code/
        raise StripeCvcCheckFailException.new
      else
        raise
      end
    end

    self.stripe_customer.try(:delete_from_stripe!) rescue nil
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
        recipient_user = User.where(facebook_id: recipient["facebook_id"]).lock(true).first_or_create!
        card_order.card_printings.create!(recipient_user: recipient_user)

        if recipient_user.requires_address_request?
          address_request = self.enqueue_address_request!({ message: recipient["address_request_message"] },
                                                            recipient: recipient_user,
                                                            app: app,
                                                            medium: :facebook_message)

          if recipient["supplied_address_api_response_id"]
            supplied_address_api_response = AddressApiResponse.find(recipient["supplied_address_api_response_id"])
            address_request.mark_as_supplied_with_address_api_response!(supplied_address_api_response)
          elsif recipient["sent_address_request"]
            address_request.mark_as_sent!
          end
        end
      end
    end
  end

  def send_notification(message, *args)
    options = args.extract_options!
    raise "Missing app" unless options[:app]

    aps_token = self.aps_tokens.where(app_id: options[:app].app_id).first

    if aps_token
      Urbanairship.push({ schedule_for: [Time.zone.now], 
                          device_tokens: [aps_token.token],
                          aps: { alert: message, sound: "notification.wav" }})
    end
  end

  def invalidate_payment_info_state!
    Rails.cache.delete(payment_info_state_cache_key)
  end

  def profile_image_url(secure = false)
    "http#{secure ? "s" : ""}://graph.facebook.com/#{self.facebook_id}/picture?width=200&height=200"
  end

  def credits_for_app(app)
    CreditJournalEntry.credits_for_user_id(self.user_id, app: app)
  end

  def add_credits!(credits, *args)
    options = args.extract_options!
    app = options[:app]
    source_type = options[:source_type] || :unknown
    source_id = options[:source_id] || self.user_id

    raise ArgumentError.new("Must specify app") unless app
    raise ArgumentError.new("Credits must be positive") if credits <= 0
    self.credit_journal_entries.create!(amount: credits, app: app, source_type: source_type, source_id: source_id)
    self.credits_for_app(app)
  end

  def deduct_credits!(credits, *args)
    options = args.extract_options!
    app = options[:app]
    source_type = options[:source_type] || :unknown
    source_id = options[:source_id] || self.user_id

    raise ArgumentError.new("Must specify app") unless app
    raise ArgumentError.new("Credits must be positive") if credits <= 0
    raise InsufficientCreditsError.new unless self.credits_for_app(app) >= credits
    self.credit_journal_entries.create!(amount: -credits, app: app, source_type: source_type, source_id: source_id)
    self.credits_for_app(app)
  end

  private 

  def ensure_order_payload_valid(payload, *args)
    errors = []
    options = args.extract_options!

    raise_order_exception = lambda do |error_type|
      raise OrderCreationException.new(error_type)
    end

    raise_order_exception.(:no_app_specified) unless payload["app"]
    app = App.by_name(payload["app"])

    unless self.payment_info_state == :active
      raise_order_exception.("#{self.payment_info_state.to_s}_payment".to_sym)
    end

    raise_order_exception.(:no_recipients) unless payload["recipients"] && payload["recipients"].size > 0
    number_of_cards_to_send = payload["recipients"].size
    raise_order_exception.(:max_recipients_reached) if number_of_cards_to_send > CONFIG.max_cards_to_send

    payload["recipients"].each do |recipient|
      facebook_id = recipient["facebook_id"]
      granted = recipient["granted_address_request_permission"]
      sent = recipient["sent_address_request"]
      message = recipient["address_request_message"]

      recipient_user = User.where(facebook_id: facebook_id).lock(true).first_or_create!

      if recipient_user.requires_address_request? 
        unless recipient["granted_address_request_permission"] || recipient["sent_address_request"] || recipient["supplied_address_api_response_id"]
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

  def payment_info_state_cache_key
    [:payment_info_state, self]
  end
end

