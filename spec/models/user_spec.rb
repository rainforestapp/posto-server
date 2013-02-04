require 'spec_helper'

describe User do
  def stub_api_with_profile(profile)
    double("api").tap do |api|
      api.stub(get_object: profile)
    end
  end

  def default_profile
    profile_with({})
  end

  def profile_with(params = {})
    loc = { id: "123", name: "Redwood City, California" }
    loc.stringify_keys!

    profile = { id: "403143",
                name: "Greg Fodor",
                first_name: "Greg",
                last_name: "Fodor",
                location: loc,
                middle_name: "Bub",
                birthday: "05/23/1981",
                gender: "male",
                email: "gfodor@gmail.com" }
    
    profile.merge!(params)

    profile.tap { |p| p.stringify_keys! }
  end

  it "should create a user with a facebook token" do
    token = "AAACEdEose0cBAAPSIS3teDWUrk0pesxwoOk0PjGzYReaZAdYzb2ITFrmtiK7cP3DBZCFWsMcGkFZBVVL1ZCMQUSRUFV172XnCZCkYFJDEPwZDZD"

    user = User.first_or_create_with_facebook_token(token, api: stub_api_with_profile(default_profile))
    original_user_id = user.user_id
    user.facebook_id.should == "403143"
    user = User.first_or_create_with_facebook_token(token, api: stub_api_with_profile(default_profile))
    user.user_id.should == original_user_id
  end

  it "should update profile" do
    token = "AAACEdEose0cBAAPSIS3teDWUrk0pesxwoOk0PjGzYReaZAdYzb2ITFrmtiK7cP3DBZCFWsMcGkFZBVVL1ZCMQUSRUFV172XnCZCkYFJDEPwZDZD"

    user = User.first_or_create_with_facebook_token(token, api: stub_api_with_profile(default_profile))
    user.user_profile.email.should == "gfodor@gmail.com"
    first_profile = user.user_profile
    first_profile.should be_latest

    UserProfile.update_all("latest = 'f'", "user_id = #{user.user_profile.user_id}")
    User.first_or_create_with_facebook_token(token, api: stub_api_with_profile(profile_with(email: "gfodor2@gmail.com")))
    user.reload.user_profile.email.should == "gfodor2@gmail.com"
    first_profile.reload.should_not be_latest
    user.user_profile.reload.should be_latest
  end
end
