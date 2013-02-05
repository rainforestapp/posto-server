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
    user = User.first_or_create_with_facebook_token("", api: stub_api_with_profile(default_profile))
    original_user_id = user.user_id
    user.facebook_id.should == "403143"
    user = User.first_or_create_with_facebook_token("", api: stub_api_with_profile(default_profile))
    user.user_id.should == original_user_id
  end

  it "should update profile" do
    user = User.first_or_create_with_facebook_token("", api: stub_api_with_profile(default_profile))
    user.reload.user_profile.email.should == "gfodor@gmail.com"
    first_profile = user.user_profile
    first_profile.should be_latest
    first_profile.birthday.to_s.should == "1981-05-23 00:00:00 UTC"
    first_profile.name.should == "Greg Fodor"
    first_profile.first_name.should == "Greg"
    first_profile.last_name.should == "Fodor"
    first_profile.location.should == "Redwood City, California"
    first_profile.middle_name.should == "Bub"
    first_profile.gender.should == "male"
    first_profile.email.should == "gfodor@gmail.com" 

    UserProfile.update_all("latest = 'f'", "user_id = #{user.user_profile.user_id}")
    User.first_or_create_with_facebook_token("", api: stub_api_with_profile(profile_with(email: "gfodor2@gmail.com")))
    user.reload.user_profile.email.should == "gfodor2@gmail.com"
    first_profile.reload.should_not be_latest
    user.user_profile.reload.should be_latest
  end

  it "should add to facebook token records" do
    user = User.first_or_create_with_facebook_token("token1", api: stub_api_with_profile(default_profile))
    facebook_token_record = user.facebook_token
    facebook_token_record.token.should == "token1"
    facebook_token_record.state.should == :active
    user = User.first_or_create_with_facebook_token("token1", api: stub_api_with_profile(default_profile))
    user.reload.facebook_token.should == facebook_token_record
    user = User.first_or_create_with_facebook_token("token2", api: stub_api_with_profile(default_profile))
    user.reload.facebook_token.token.should == "token2"
  end

  it "should mark facebook token record as expired" do
    user = User.first_or_create_with_facebook_token("token1", api: stub_api_with_profile(default_profile))
    facebook_token_record = user.facebook_token
    facebook_token_record.state.should == :active

    evil_api = double("api").tap do |api|
      api.stub(:get_object).and_raise(Koala::Facebook::AuthenticationError.new(401, ""))
    end

    user = User.first_or_create_with_facebook_token("token1", api: evil_api)
    facebook_token_record.reload.state.should == :expired
  end

  it "should generate api key and expire after regenerated" do
    user = create(:user)
    user.api_key.should be nil
    user.renew_api_key!
    user.reload.api_key.should_not be_nil
    current_api_key = user.api_key
    user.renew_api_key!
    current_api_key.reload.should_not be_active
    user.reload.api_key.should_not be_nil
    user.reload.api_key.should be_active
  end
end
