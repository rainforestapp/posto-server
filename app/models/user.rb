class User < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include TransactionRetryable
  include HasUid

  CONTACT_REMOTE_ID_PREFIX = "ios_c_"

  has_one_audited :user_profile
  has_one_audited :api_key
  has_one_audited :facebook_token
  has_one_audited :stripe_customer
  has_one_audited :recipient_address, foreign_key: "recipient_user_id"
  has_one_audited :birthday_request_response, foreign_key: "recipient_user_id"

  has_many :sent_address_requests, foreign_key: "request_sender_user_id", class_name: "AddressRequest", order: "created_at desc"
  has_many :received_address_requests, foreign_key: "request_recipient_user_id", class_name: "AddressRequest", order: "created_at desc"
  has_many :sent_birthday_requests, foreign_key: "request_sender_user_id", class_name: "BirthdayRequest", order: "created_at desc"
  has_many :received_birthday_requests, foreign_key: "request_recipient_user_id", class_name: "BirthdayRequest", order: "created_at desc"
  has_many :card_orders, foreign_key: "order_sender_user_id"
  has_many :authored_card_designs, foreign_key: "author_user_id", class_name: "CardDesign"
  has_many :card_printings, foreign_key: "recipient_user_id"
  has_many :authored_card_images, foreign_key: "author_user_id", class_name: "CardImage"
  has_many :aps_tokens, order: "aps_token_id desc"
  has_many :user_logins
  has_many :credit_orders
  has_many :credit_journal_entries
  has_many :credit_plan_memberships, order: "created_at desc"
  has_many :postcard_subjects

  attr_accessible :uid

  after_save :invalidate_token_cache_entry!

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
    birthday_day = nil
    birthday_month = nil
    birthday_year = nil

    if facebook_response["birthday"]
      birthday = Chronic.parse(facebook_response["birthday"] + " 00:00:00")
      birthday_day = birthday.day
      birthday_month = birthday.month
      birthday_year = birthday.year
    end

    user.tap do |user|
      new_fields = { user_id: user.user_id,
                     name: facebook_response["name"],
                     first_name: facebook_response["first_name"],
                     last_name: facebook_response["last_name"],
                     location: location,
                     middle_name: facebook_response["middle_name"],
                     birthday: birthday,
                     birthday_day: birthday_day,
                     birthday_month: birthday_month,
                     birthday_year: birthday_year,
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

  def refresh_user_profile!
    return self unless self.facebook_token.try(:token)

    begin
      return User.first_or_create_with_facebook_token(self.facebook_token.token)
    rescue Exception => e
      # Just in case token expired, etc.
      return self
    end
  end

  def create_and_publish_image_file!(file_path, *args)
    options = args.extract_options!
    raise "Missing argument: app" unless options[:app]

    image = Magick::Image.read(file_path).first
    raise "No image found at #{file_path}" unless image

    CONFIG.for_app(options[:app]) do |config|
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
    !!recipient_address.try(:up_to_date?)
  end

  def has_pending_address_request?
    received_address_requests.first.try(:pending?)
  end

  def has_sent_orders?
    self.card_orders.reject { |o| o.is_promo }.size > 0
  end

  def self.user_id_for_facebook_id(facebook_id)
    Rails.cache.fetch(["user_id_for_fb_id", facebook_id]) do
      User.where(facebook_id: facebook_id).first_or_create!.user_id
    end
  end

  def self.birthday_for_facebook_id(facebook_id)
    self.birthday_for_user_id(self.user_id_for_facebook_id(facebook_id))
  end

  def self.birthday_for_user_id(user_id)
    Rails.cache.fetch(birthday_cache_key_for_user_id(user_id)) do
      user = User.find(user_id)

      if user
        user.user_profile.try(:birthday) || user.birthday_request_response.try(:birthday)
      else
        nil
      end
    end
  end

  def self.invalidate_birthday_for_user_id(user_id)
    Rails.cache.delete(birthday_cache_key_for_user_id(user_id))
  end

  def self.birthday_cache_key_for_user_id(user_id)
    ["cached_birthday", user_id]
  end

  def birthday
    User.birthday_for_user_id(self.user_id)
  end

  def printable_birthday
    birthday = self.birthday
    return "" unless birthday
    "#{birthday.strftime("%B")} #{birthday.day.ordinalize}"
  end

  def has_birthday?
    !birthday.nil?
  end

  def has_pending_birthday_request?
    received_birthday_requests.first.try(:pending?)
  end

  def requires_address_request?
    !has_up_to_date_address? && !has_pending_address_request?
  end

  def requires_birthday_request?
    !has_birthday? && !has_pending_birthday_request?
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

  def enqueue_birthday_request!(*args)
    options = args.extract_options!

    self.sent_birthday_requests.create!(
      request_recipient_user: options[:recipient],
      app: options[:app],
      birthday_request_medium: options[:medium],
      birthday_request_payload: args[0],
    )
  end

  def credit_plan_id_for_app(app)
    membership_map = Rails.cache.fetch(credit_plan_membership_state_cache_key) do
      {}.tap do |map|
        self.credit_plan_memberships.each do |membership|
          if membership.active?
            map[membership.app_id] ||= membership.credit_plan_id
          end
        end
      end
    end

    membership_map[app.app_id]
  end

  def credit_plan_membership_for_app(app)
    return nil unless credit_plan_id_for_app(app)

    self.credit_plan_memberships.each do |membership|
      if membership.app == app && membership.active?
        return membership
      end
    end
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
    options = args.extract_options!
    is_promo = !!options[:is_promo]

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

    # Issue where composed image does not show up
    image_ids["composed_full_photo_image"] ||= image_ids["edited_full_photo"] || image_ids["original_full_photo"]

    photo_taken_at = nil

    if payload["photo_taken_at"]
      photo_taken_at = Chronic.parse(payload["photo_taken_at"])
    end

    design_type = :lulcards_alpha
    design_type = :babygrams_alpha if app == App.babygrams

    card_design_args = payload["card_design"]
                        .except(*image_types)
                        .merge(design_type: design_type, app: app)
                        .merge(image_ids)
                        .merge(note: payload["note"], 
                               photo_is_user_generated: payload["photo_is_user_generated"],
                               photo_taken_at: photo_taken_at)

    card_design = self.authored_card_designs.create!(card_design_args)

    card_order = self.card_orders.create!(app: app,
                                          is_promo: is_promo,
                                          card_design: card_design,
                                          quoted_total_price: payload["quoted_total_price"])

    card_order.tap do |card_order|
      payload["recipients"].each do |recipient|
        remote_id = recipient["recipient_id"] || recipient["facebook_id"]

        recipient_user = User.where(facebook_id: remote_id).lock(true).first_or_create!
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

      if payload["quoted_total_credits"]
        card_order.allocate_and_deduct_credits!
      end
    end
  end

  def send_notification(message, *args)
    options = args.extract_options!
    raise "Missing app" unless options[:app]

    CONFIG.for_app(options[:app]) do |config|
      aps_token = self.aps_tokens.where(app_id: options[:app].app_id).first

      if aps_token
        urban_airship = Urbanairship::Client.new
        urban_airship.application_key = config.urban_airship_application_key
        urban_airship.application_secret = config.urban_airship_application_secret
        urban_airship.master_secret = config.urban_airship_master_secret
        urban_airship.logger = Rails.logger
        urban_airship.request_timeout = 5
        urban_airship.push({ schedule_for: [Time.zone.now], 
                            device_tokens: [aps_token.token],
                            aps: { alert: message, sound: "notification.wav" }})
      end
    end
  end

  def invalidate_payment_info_state!
    Rails.cache.delete(payment_info_state_cache_key)
  end

  def invalidate_credit_plan_membership_state!
    Rails.cache.delete(credit_plan_membership_state_cache_key)
  end

  def profile_image_url(secure = false)
    "http#{secure ? "s" : ""}://graph.facebook.com/#{self.facebook_id}/picture?width=200&height=200"
  end

  def credits_for_app(app)
    CreditJournalEntry.credits_for_user_id(self.user_id, app: app)
  end

  def has_empty_credit_journal_for_app?(app)
    CreditJournalEntry.credit_journal_size_for_user_id(self.user_id, app: app) == 0
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

  def remaining_credited_cards_for_card_order_for_app(app)
    CONFIG.for_app(app) do |config|
      credits = self.credits_for_app(app)
      return 0 if credits < (config.processing_credits + config.card_credits)
      ((credits - config.processing_credits).to_f / config.card_credits.to_f).floor
    end
  end

  def number_of_credited_cards_for_order_of_size(number_of_cards, *args)
    options = args.extract_options!
    app = options[:app]
    raise ArgumentError.new unless app

    [self.remaining_credited_cards_for_card_order_for_app(app), number_of_cards].min
  end

  def credits_to_allocate_for_order_of_size(number_of_cards, *args)
    number_of_credited_cards = number_of_credited_cards_for_order_of_size(number_of_cards, *args)
    return 0 if number_of_credited_cards == 0

    options = args.extract_options!
    app = options[:app]
    raise ArgumentError.new unless app

    CONFIG.for_app(app) do |config|
      config.processing_credits + (config.card_credits * number_of_credited_cards) 
    end
  end

  def handle_signup_bonuses_for_app!(app)
    sent_referral_notification = false

    CONFIG.for_app(app) do |config|
      self.class.transaction_with_retry do
        if self.has_empty_credit_journal_for_app?(app)
          if config.signup_credits > 0
            self.add_credits!(config.signup_credits,
                              app: app,
                              source_type: :signup,
                              source_id: self.user_id)
          end

          referrals = UserReferral.where(referred_user_id: self.user_id,
                                         app_id: app.app_id)

          self_referral_granted = false

          referrals.each do |referral|
            unless referral.state == :granted
              referral.state = :granted
              referring_user = referral.referring_user
              referring_user.add_credits!(config.referral_credits,
                                          app: app,
                                          source_type: :referral,
                                          source_id: self.user_id)

              unless self_referral_granted
                self_referral_granted = true

                self.add_credits!(config.referral_credits,
                                  app: app,
                                  source_type: :referral,
                                  source_id: self.user_id)
              end

              unless sent_referral_notification
                message = "#{self.user_profile.name} joined #{config.app_name}, so you earned #{config.referral_credits} credits!"
                referring_user.send_notification(message, app: app)
                EarnedCreditsMailer.referral(referring_user, self, app).deliver
              end
            end
          end
        end
      end
    end
  end

  def set_birthday_reminders(reminders, *args)
    options = args.extract_options!

    raise ArgumentError.new("missing app") unless options[:app]

    facebook_ids = reminders.map { |r| r[:facebook_id] }

    existing_users = User.where(facebook_id: facebook_ids)
                         .includes(:recipient_addresses, :user_profiles, :birthday_request_responses).to_a

    [].tap do |requests|
      reminders.each do |reminder|
        facebook_id = reminder[:facebook_id]
        user = existing_users.find { |u| u.facebook_id == facebook_id }
        user ||= User.where(facebook_id: facebook_id).first_or_create!

        unless user.has_birthday?
          if reminder[:supplied_birthday]
            birthday = nil

            if /^[01][0-9]\/[0-3][0-9]\/[0-9][0-9][0-9][0-9]$/ =~ reminder[:supplied_birthday]
              birthday = Chronic.parse("#{reminder[:supplied_birthday]} 00:00:00")
            elsif /^[01][0-9]\/[0-3][0-9]$/ =~ reminder[:supplied_birthday]
              birthday = Chronic.parse("#{reminder[:supplied_birthday]}/1904 00:00:00")
            end

            unless birthday
              raise ArgumentError.new("birthday #{reminder}") 
            end

            user.birthday_request_responses.create!(birthday: birthday,
                                                    sender_user_id: self.user_id)
          else
            if user.requires_birthday_request?
              birthday_request = self.sent_birthday_requests.create!(
                request_recipient_user: user,
                app: options[:app],
                birthday_request_medium: :facebook_message,
                birthday_request_payload: { message: reminder[:birthday_request_message] },
              )

              birthday_request.state = reminder[:birthday_request_sent] ? :sent : :outgoing

              requests << birthday_request
            end
          end
        end
      end

      if Rails.env == "production"
        execute_birthday_requests_workflow!(requests)
      end
    end
  end

  def is_contact?
    self.facebook_id =~ /^#{CONTACT_REMOTE_ID_PREFIX}/
  end

  def last_card_order
    self.card_orders.sort_by(&:created_at)[-1]
  end

  def first_order
    self.card_orders.sort_by(&:created_at)[0]
  end

  def is_opted_out_of_email_class?(email_class)
    opt_out = EmailOptOut.where(recipient_user_id: self.user_id, email_class: email_class).first
    opt_out && opt_out.try(:state) == :opted_out
  end

  def opt_out_of_email_class!(email_class)
    opt_out = EmailOptOut.where(recipient_user_id: self.user_id, email_class: email_class).first_or_create!
    opt_out.state = :opted_out
  end

  def migrate_postcard_subjects!
    postcard_subjects = self.card_orders.where(app_id: App.babygrams.app_id).map(&:card_design).map(&:postcard_subject).flatten.uniq
    self.set_postcard_subjects(postcard_subjects, app: App.babygrams)
  end

  def set_postcard_subjects(subjects, *args)
    options = args.extract_options!
    raise "Missing app" unless options[:app]

    subject_map = {}

    # Look up existing
    subjects.each do |subject|
      existing = self.postcard_subjects.where(name: subject[:name],
                                              postcard_subject_type: subject[:subject_type],
                                              gender: subject[:gender],
                                              app_id: options[:app].app_id)

      existing.each do |existing_subject|
        if existing_subject.birthday == subject[:birthday] &&
           existing_subject.state == :active
          subject_map[subject] = existing_subject
        end
      end
    end

    # Remove those missing
    to_remove = Set.new

    self.postcard_subjects.reload.each do |subject|
      unless subject_map.values.include?(subject)
        to_remove << subject
      end
    end

    to_remove.each { |s| s.state = :removed }

    subjects.each do |subject|
      next if subject_map[subject]

      self.postcard_subjects.create(name: subject[:name],
                                    birthday: subject[:birthday],
                                    postcard_subject_type: subject[:subject_type],
                                    gender: subject[:gender],
                                    app_id: options[:app].app_id)
    end
  end

  private 

  def execute_birthday_requests_workflow!(birthday_requests)
    return if birthday_requests.size == 0

    swf = AWS::SimpleWorkflow.new
    domain = swf.domains["posto-#{Rails.env == "production" ? "prod" : "dev"}"]
    workflow_type = domain.workflow_types['BirthdayRequestWorkflow.processRequests', CONFIG.for_app(birthday_requests[0].app).birthday_request_workflow_version]
    java_request_ids = birthday_requests.map { |r| r.birthday_request_id }
    input = ["[Ljava.lang.Object;", 
            [["[Ljava.lang.Long;", java_request_ids]]].to_json
    workflow_id = "user-birthdays-#{self.user_id.to_s}-#{SecureRandom.hex}"

    tags = []

    workflow_type.start_execution input: input, workflow_id: workflow_id, tag_list: tags
  end

  def ensure_order_payload_valid(payload, *args)
    errors = []
    options = args.extract_options!
    is_promo = options[:is_promo]

    ensure_promo_order_payload_valid(payload, *args) if is_promo

    raise_order_exception = lambda do |error_type|
      raise OrderCreationException.new(error_type)
    end

    raise_order_exception.(:no_app_specified) unless payload["app"]
    app = App.by_name(payload["app"])
    raise_order_exception.(:no_app_specified) unless app

    # Just to be safe, read credit journal from disk.
    CreditJournalEntry.invalidate_cache_for_user_id!(self.user_id, app_id: app.app_id)

    raise_order_exception.(:no_recipients) unless payload["recipients"] && payload["recipients"].size > 0
    number_of_cards_to_send = payload["recipients"].size
    raise_order_exception.(:max_recipients_reached) if number_of_cards_to_send > CONFIG.for_app(app).max_cards_to_send

    payload["recipients"].each do |recipient|
      remote_id = recipient["facebook_id"]
      recipient_type = :facebook

      if recipient["recipient_id"]
        raise_order_exception.(:no_recipient_type) unless ["facebook", "contact"].include?(recipient["recipient_type"])
        recipient_type = recipient["recipient_type"].to_sym
        remote_id = recipient["recipient_id"]

        if recipient_type == :contact
          unless remote_id =~ /^#{CONTACT_REMOTE_ID_PREFIX}/ && remote_id =~ /_#{self.facebook_id}$/
            raise_order_exception.(:bad_contact_recipient_id)
          end
        end
      end

      granted = recipient["granted_address_request_permission"]
      sent = recipient["sent_address_request"]
      message = recipient["address_request_message"]

      recipient_user = User.where(facebook_id: remote_id).lock(true).first_or_create!

      # Create or update the profile if this is a contact.
      if recipient_type == :contact
        recipient_user_profile_fields = recipient.slice("first_name", "last_name", "name").symbolize_keys
        recipient_user_profile_fields[:user_id] = recipient_user.user_id

        unless recipient_user_profile_fields[:name].blank? ||
               recipient_user.user_profile.try(:name) == recipient_user_profile_fields[:name]
          UserProfile.where(recipient_user_profile_fields).first_or_create!
        end
      end

      if recipient_user.requires_address_request? 
        unless recipient["granted_address_request_permission"] || recipient["sent_address_request"] || recipient["supplied_address_api_response_id"]
          raise_order_exception.(:needs_recipient_address_requests)
        end

        raise_order_exception.(:missing_address_request_message) unless recipient["address_request_message"].kind_of?(String)
      end
    end

    credits_to_allocate = 0
    number_of_credited_cards = 0

    unless is_promo
      if payload["quoted_total_credits"]
        if credits_for_app(app) < payload["quoted_total_credits"]
          raise_order_exception.(:insufficient_credits)
        end

        number_of_credited_cards = self.number_of_credited_cards_for_order_of_size(number_of_cards_to_send, app: app)

        if number_of_credited_cards > 0
          credits_to_allocate = self.credits_to_allocate_for_order_of_size(number_of_cards_to_send, app:app)
        end

        unless payload["quoted_total_credits"] == credits_to_allocate
          raise_order_exception.(:misquoted_credits)
        end
      end
    else
      number_of_credited_cards = number_of_cards_to_send
    end

    total_price = 0

    number_of_payable_cards = number_of_cards_to_send - number_of_credited_cards

    if number_of_payable_cards > 0
      total_price = CONFIG.for_app(app).processing_fee + (CONFIG.for_app(app).card_fee * number_of_payable_cards)
    end

    unless payload["quoted_total_price"] == total_price || is_promo
      raise_order_exception.(:misquoted_total_price)
    end

    if total_price > 0
      unless self.payment_info_state == :active
        raise_order_exception.("#{self.payment_info_state.to_s}_payment".to_sym)
      end
    end

    raise_order_exception.(:no_card_design) unless payload["card_design"]
  end

  def ensure_promo_order_payload_valid(payload, *args)
    errors = []
    options = args.extract_options!

    raise_order_exception = lambda do |error_type|
      raise OrderCreationException.new(error_type)
    end

    raise_order_exception.(:invalid_promo_recipients) unless payload["recipients"] && payload["recipients"].size == 1
    raise_order_exception.(:invalid_promo_recipients) if payload["recipients"][0]["recipient_id"] != self.facebook_id
    raise_order_exception.(:promo_already_sent) if self.sent_promo_card
  end

  def payment_info_state_cache_key
    [:payment_info_state, self]
  end

  def credit_plan_membership_state_cache_key
    [:credit_plan_membership, self]
  end

  def invalidate_token_cache_entry!
    Api::V1::TokensController.clear_token_cache_for_user_id(self.user_id)
  end
end

