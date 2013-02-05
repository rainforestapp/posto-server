class User < ActiveRecord::Base
  include AppendOnlyModel

  has_one :user_profile, order: "created_at desc"
  has_one :api_key, order: "created_at desc"
  has_one :facebook_token, order: "created_at desc"

  def self.first_or_create_with_facebook_token(facebook_token, *args)
    options = args.extract_options!
    api = options[:api] || Koala::Facebook::API.new(facebook_token)
    user = nil

    begin
      profile = api.get_object("me?fields=name,first_name,middle_name,last_name,location,gender,email,birthday")
      facebook_id = profile["id"]

      user = User.where(:facebook_id => facebook_id).first_or_create!

      location = nil
      location = profile["location"]["name"] if profile["location"]

      birthday = nil
      birthday = Chronic.parse(profile["birthday"] + " 00:00:00") if profile["birthday"]

      FacebookToken.where(:user_id => user.user_id, :token => facebook_token).first_or_create!

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
      if user && user.facebook_token && user.facebook_token.token == facebook_token
        user.facebook_token = :expired 
      end

      # TODO log authentication error
      return nil
    end
  end

  def renew_api_key!
    ApiKey.where(user_id: self.user_id).create!
  end
end

