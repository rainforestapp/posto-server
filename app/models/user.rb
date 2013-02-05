class User < ActiveRecord::Base
  include AppendOnlyModel
  include HasAppendOnly

  has_append_only :user_profile
  has_append_only :api_key
  has_append_only :facebook_token

  def self.first_or_create_with_facebook_token(facebook_token, *args)
    options = args.extract_options!
    api = options[:api] || Koala::Facebook::API.new(facebook_token)
    facebook_token_record = FacebookToken.where(:token => facebook_token).first

    begin
      profile = api.get_object("me?fields=name,first_name,middle_name,last_name,location,gender,email,birthday")
      facebook_id = profile["id"]

      user = User.where(:facebook_id => facebook_id).first_or_create!

      location = nil
      location = profile["location"]["name"] if profile["location"]

      birthday = nil
      birthday = Chronic.parse(profile["birthday"] + " 00:00:00") if profile["birthday"]

      facebook_token_record = FacebookToken.where(:user_id => user.user_id, :token => facebook_token).first_or_create!

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

  def renew_api_key!
    ApiKey.where(user_id: self.user_id).create!
  end
end

