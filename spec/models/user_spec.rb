require 'spec_helper'

describe User do
  def stub_api_with(params)
    double("api").tap do |api|
      api.stub(:get_object) do |path|
        case path
        when /^\/?me[\?$]/
          params[:profile]
        when /^\/?me\/friends[\?$]/
          params[:friends]
        end
      end
    end
  end

  def stub_api_with_profile(profile)
    stub_api_with(profile: profile)
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

    UserProfile.update_all("latest = 0", "user_id = #{user.user_profile.user_id}")
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
  
  it "should not let order be created if no recipients" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    stub_api = stub_api_with_profile(default_profile)

    expect(lambda do
      user.create_order_from_payload!({ "facebook_token" => "foobar", "app" => "lulcards", }, api: stub_api)
    end).to raise_error(OrderCreationException, /no_recipients/)
  end

  it "should not let order be created if too many recipients" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    stub_api = stub_api_with_profile(default_profile)
    stub_recipient = { }

    expect(lambda do
      user.create_order_from_payload!({ "facebook_token" => "foobar", "app" => "lulcards",
                                        "recipients" => [stub_recipient] * 15 }, api: stub_api)
    end).to raise_error(OrderCreationException, /max_recipients_reached/)
  end

  
  it "should not let order be created if friends need requests and not included" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }])
    stub_recipient = { "facebook_id" => friend_id }

    expect(lambda do
      user.create_order_from_payload!({ "facebook_token" => "foobar", "app" => "lulcards",
                                        "recipients" => [stub_recipient] }, api: stub_api)
    end).to raise_error(OrderCreationException, /needs_recipient_address_requests/)
  end

  it "should not let order be created if price is not quoted correctly" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }])
    stub_recipient = { "facebook_id" => friend_id, 
                       "address_request_message" => "What's your address?",
                       "granted_address_request_permission" => true }

    expect(lambda do
      user.create_order_from_payload!({ "facebook_token" => "foobar", 
                                        "app" => "lulcards",
                                        "recipients" => [stub_recipient], 
                                        "quoted_total_price" => 99 }, api: stub_api)
    end).to raise_error(OrderCreationException, /misquoted_total_price/)
  end

  it "should not let order be created if no design specified" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }])
    stub_recipient = { "facebook_id" => friend_id, 
                       "address_request_message" => "What's your address?",
                       "granted_address_request_permission" => true }

    expect(lambda do
      user.create_order_from_payload!({ "facebook_token" => "foobar", 
                                        "app" => "lulcards",
                                        "recipients" => [stub_recipient], 
                                        "quoted_total_price" => 124 }, api: stub_api)
    end).to raise_error(OrderCreationException, /no_card_design/)
  end
  
  it "should not let order be created if no design specified" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }])
    stub_recipient = { "facebook_id" => friend_id, 
                       "address_request_message" => "What's your address?",
                       "granted_address_request_permission" => true }

    expect(lambda do
      user.create_order_from_payload!({ "facebook_token" => "foobar", 
                                        "app" => "lulcards",
                                        "recipients" => [stub_recipient], 
                                        "quoted_total_price" => 124 }, api: stub_api)
    end).to raise_error(OrderCreationException, /no_card_design/)
  end
  
  def stub_order_request_recipient_for_friend_id(friend_id)
    { 
      "facebook_id" => friend_id, 
      "address_request_message" => "What's your address?",
      "granted_address_request_permission" => true 
    }
  end

  def stub_order_request_recipient_for_contact_id(contact_id)
    { 
      "recipient_id" => contact_id, 
      "address_request_message" => "What's your address?",
      "granted_address_request_permission" => true,
      "recipient_type" => "contact",
      "first_name" => "Bubba", 
      "last_name" => "Jones", 
      "name" => "Bubba Jones", 
    }
  end

  def stub_order_request_card_design
    {
      "source_card_design_id" => nil,
      "top_caption" => "hello",
      "bottom_caption" => "world",
      "top_caption_font_size" => 32,
      "bottom_caption_font_size" => 32,
      "original_full_photo" => { "width" => 320, "height" => 460, "image_format" => "jpg",
                                 "orientation" => "up", "uuid" => "original_uuid", },
      "edited_full_photo" => { "width" => 320, "height" => 460, "image_format" => "jpg",
                               "orientation" => "down", "uuid" => "edited_uuid", },
      "composed_full_photo" => { "width" => 320, "height" => 460, "image_format" => "jpg",
                                 "orientation" => "left", "uuid" => "composed_uuid", }
    }
  end

  it "should create order with full payment if everything kosher" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }])

    recipient = stub_order_request_recipient_for_friend_id(friend_id) 

    card_design = stub_order_request_card_design

    order = user.create_order_from_payload!({ "facebook_token" => "foobar", 
                                              "app" => "lulcards",
                                              "recipients" => [recipient], 
                                              "card_design" => card_design,
                                              "quoted_total_price" => 124 }, api: stub_api)

    order.card_printings.size.should == 1
  end

  it "should create order and user profile with legit contact id" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }])

    recipient = stub_order_request_recipient_for_contact_id("ios_c_123_#{user.facebook_id}") 

    card_design = stub_order_request_card_design

    order = user.create_order_from_payload!({ "facebook_token" => "foobar", 
                                              "app" => "lulcards",
                                              "recipients" => [recipient], 
                                              "card_design" => card_design,
                                              "quoted_total_price" => 124 }, api: stub_api)

    order.card_printings.size.should == 1
    recipient_user = User.where(facebook_id: "ios_c_123_#{user.facebook_id}").first
    recipient_user.user_profile.first_name.should == "Bubba"
    recipient_user.user_profile.last_name.should == "Jones"
    recipient_user.user_profile.name.should == "Bubba Jones"
  end

  it "should not create order with contact recipient with bad remote id" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }])
    recipient = stub_order_request_recipient_for_contact_id("foobar")
    card_design = stub_order_request_card_design

    expect(lambda do
      order = user.create_order_from_payload!({ "facebook_token" => "foobar", 
                                                "app" => "lulcards",
                                                "recipients" => [recipient], 
                                                "card_design" => card_design,
                                                "quoted_total_price" => 124 }, api: stub_api)
    end).to raise_error(OrderCreationException, /bad_contact_recipient_id/)
  end

  it "should not create order with credits if insufficient credits" do
    user = create(:greg_user)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }])

    recipient = stub_order_request_recipient_for_friend_id(friend_id) 

    card_design = stub_order_request_card_design

    expect(lambda do
      order = user.create_order_from_payload!({ "facebook_token" => "foobar", 
                                                "app" => "lulcards",
                                                "recipients" => [recipient], 
                                                "card_design" => card_design,
                                                "quoted_total_price" => 0,
                                                "quoted_total_credits" => 10}, api: stub_api)

    end).to raise_error(OrderCreationException, /insufficient_credits/)
  end

  it "should not create order with credits if misquoted credits" do
    user = create(:greg_user)
    user.add_credits!(10, app: App.lulcards)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }])

    recipient = stub_order_request_recipient_for_friend_id(friend_id) 

    card_design = stub_order_request_card_design

    expect(lambda do
      order = user.create_order_from_payload!({ "facebook_token" => "foobar", 
                                                "app" => "lulcards",
                                                "recipients" => [recipient], 
                                                "card_design" => card_design,
                                                "quoted_total_price" => 0,
                                                "quoted_total_credits" => 7}, api: stub_api)

    end).to raise_error(OrderCreationException, /misquoted_credits/)
  end

  it "should create order and deduct credits" do
    user = create(:greg_user)
    user.add_credits!(27, app: App.lulcards)
    user.stub(payment_info_state: :active)
    friend_id = Random.new.rand(10000).to_s
    friend_id_2 = Random.new.rand(10000).to_s
    stub_api = stub_api_with(profile: default_profile, friends: [{ "id" => friend_id }, { "id" => friend_id_2 }])

    recipients = [stub_order_request_recipient_for_friend_id(friend_id),
                  stub_order_request_recipient_for_friend_id(friend_id_2)]

    card_design = stub_order_request_card_design

    order = user.create_order_from_payload!({ "facebook_token" => "foobar", 
                                              "app" => "lulcards",
                                              "recipients" => recipients, 
                                              "card_design" => card_design,
                                              "quoted_total_price" => 0,
                                              "quoted_total_credits" => 20}, api: stub_api)

    order.card_order_credit_allocation.allocated_credits.should == 20
    user.credits_for_app(App.lulcards).should == 7
    
    # test refunding
    order.refund_allocated_credits_for_cards!(1).should == 10
    user.credits_for_app(App.lulcards).should == 17
    order.card_order_credit_allocation.allocated_credits.should == 10
    order.card_order_credit_allocation.number_of_credited_cards.should == 1

    order.refund_allocated_credits_for_cards!(1).should == 10
    user.credits_for_app(App.lulcards).should == 27
    order.card_order_credit_allocation.number_of_credited_cards.should == 0
    order.card_order_credit_allocation.allocated_credits.should == 0

    order.refund_allocated_credits_for_cards!(1).should == 0
    user.credits_for_app(App.lulcards).should == 27
    order.card_order_credit_allocation.allocated_credits.should == 0
    order.card_order_credit_allocation.number_of_credited_cards.should == 0
  end
  
  it "should credit and debit credits" do
    user = create(:greg_user)
    app = App.lulcards

    user.credits_for_app(app).should == 0
    user.add_credits!(27, app: app).should == 27
    user.credits_for_app(app).should == 27
    user.remaining_credited_cards_for_card_order_for_app(app).should == 2
    user.deduct_credits!(10, app: app).should == 17
    user.remaining_credited_cards_for_card_order_for_app(app).should == 1
    user.deduct_credits!(8, app: app).should == 9
    user.remaining_credited_cards_for_card_order_for_app(app).should == 0
    user.credits_for_app(app).should == 9

    expect(lambda do
      user.deduct_credits!(10, app: app)
    end).to raise_error(InsufficientCreditsError)
  end

  it "should create birthday requests for user" do
    user = create(:greg_user)
    app = create(:app)

    user_with_birthday = create(:birthday_request_response).recipient_user

    reminders = [
      { facebook_id: "123123", birthday_request_sent: true, birthday_request_message: "What up" },
      { facebook_id: "321321", birthday_request_sent: false, birthday_request_message: "What up" },
      { facebook_id: user_with_birthday.facebook_id, birthday_request_sent: false, birthday_request_message: "What up" },
      { facebook_id: "333333", birthday_request_sent: false, supplied_birthday: "05/23", birthday_request_message: "What up" },
    ]

    user.set_birthday_reminders(reminders, app: app)

    first_user = User.where(facebook_id: "123123").first
    first_user.should_not be_nil
    first_user.received_birthday_requests.size.should == 1
    first_user.received_birthday_requests[0].state.should == :sent
    first_user.received_birthday_requests[0].payload[:message].should == "What up"

    second_user = User.where(facebook_id: "321321").first
    second_user.should_not be_nil
    second_user.received_birthday_requests.size.should == 1
    second_user.received_birthday_requests[0].state.should == :outgoing

    third_user = User.where(facebook_id: "333333").first
    third_user.should_not be_nil
    third_user.birthday_request_responses.first.birthday.should == "Mon, 23 May 1904"
    third_user.birthday_request_responses.first.sender_user.should == user

    user_with_birthday.reload.received_birthday_requests.size.should == 0

    user.set_birthday_reminders(reminders, app: app)

    first_user.reload.received_birthday_requests.size.should == 1
    second_user.reload.received_birthday_requests.size.should == 1
    user_with_birthday.reload.received_birthday_requests.size.should == 0
  end
end
