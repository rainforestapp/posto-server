class User < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :birthday, :facebook_id, :first_name, :gender, :last_name, :location, :middle_name, :name, :user_id
  has_one :user_profile, order: "created_at desc"

  def self.first_or_create_with_facebook_token(token, *args)
    options = args.extract_options!
    api = options[:api] || Koala::Facebook::API.new(token)

    begin
      profile = api.get_object("me?fields=name,first_name,middle_name,last_name,location,gender,email,birthday")
      facebook_id = profile["id"]

      user = User.where(:facebook_id => facebook_id).first_or_create

      location = nil
      location = profile["location"]["name"] if profile["location"]

      user.tap do |user|
        UserProfile.where(user_id: user.user_id,
                          name: profile["name"],
                          first_name: profile["first_name"],
                          last_name: profile["last_name"],
                          location: location,
                          middle_name: profile["middle_name"],
                          birthday: profile["birthday"],
                          gender: profile["gender"],
                          email: profile["email"]).first_or_create
      end
    rescue Koala::Facebook::AuthenticationError => e
      # TODO log authentication error
      return nil
    end
  end
end
