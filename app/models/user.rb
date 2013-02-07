class User < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited

  has_one_audited :user_profile
  has_one_audited :api_key
  has_one_audited :facebook_token
  has_one_audited :recipient_address, foreign_key: "recipient_user_id"

  has_many :sent_address_requests, foreign_key: "request_sender_user_id", class_name: "AddressRequest", order: "created_at desc"
  has_many :received_address_requests, foreign_key: "request_recipient_user_id", class_name: "AddressRequest", order: "created_at desc"

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

  def send_address_request(*args)
    options = args.extract_options!

    self.sent_address_requests.create!(
      request_recipient_user: options[:recipient],
      app: options[:app],
      address_request_medium: options[:medium],
      address_request_payload: args[0]
    )
  end
end

