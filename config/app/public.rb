require "sampleable_config"

CONFIG = SampleableConfig.define do
  version 1
  kill_switch false
  really_kill_switch false
  mixpanel_enabled true
  mixpanel_event_screen ["address_info_failed"]
  support_email "support@lulcards.com"
  uservoice_enabled true
  testflight_enabled true
  card_order_admin_notify 1.0
  card_order_approve_amount 0.0
  address_request_admin_notify 1.0
  birthday_request_admin_notify 1.0
  admin_credit_order_audit_email "gfodor@gmail.com"
  admin_credit_order_enabled true

  card_image_host "data.lulcards.com"
  ssl_card_image_host "d19ku6gs1135cx.cloudfront.net"
  card_image_bucket "posto-data"

  csv_host "d19ku6gs1135cx.cloudfront.net"
  csv_bucket "posto-data"

  stripe_publishable_key ENV["STRIPE_PUBLISHABLE_KEY"]

  app "lulcards" do
    entity "lulcard"
    mixpanel_token "949dc3069c44a97df45c04d8293ec2ed"
    mixpanel_people_enabled false
    mixpanel_revenue_enabled false
    page_title "lulcards: send hilarious real meme postcards"
    page_tagline "Send hilarious meme postcards, right from your phone."
    from_email "lulcards orders <orders@lulcards.com>"
    facebook_app_id ENV["FB_API_KEY"]
    facebook_api_secret ENV["FB_API_SECRET"]
    fb_permissions ["email", "read_mailbox", "xmpp_login", "user_location", "user_birthday", "friends_location", "user_photos", "friends_photos", "friends_birthday"]
    fb_photo_permissions ["user_photos", "friends_photos"]
    itunes_url "itms://itunes.apple.com/us/app/lulcards/id585112745?ls=1&mt=8"
    marketing_url "http://lulcards.com"
    kill_message "lulcards is unavailable."
    urban_airship_application_key ENV["URBAN_AIRSHIP_APP_KEY"]
    urban_airship_application_secret ENV["URBAN_AIRSHIP_APP_SECRET"]
    urban_airship_master_secret ENV["URBAN_AIRSHIP_MASTER_SECRET"]
    nag_version 3
    nag_app_versions ["1.0", "1.0.1", "1.1", "1.1.1"]
    nag_title "New Version Available"
    nag_message "A new version of lulcards is available. Upgrade now to send birthday lulcards and share cards on Facebook!"
    nag_action "Update"
    nag_target "itms://itunes.apple.com/us/app/lulcards/id585112745?ls=1&mt=8"
    share_caption "Check out this card I got from NAME! #lulcards"
    invite_sms_message "I've been sending hilarious REAL photos to people in the mail with lulcards, check it out! LINK"
    invite_share_message "#lulcards lets you send hilarious REAL photos to friends in the mail. check it out!"
    invite_url_prefix "http://lulcards.com/ref"
    invite_share_image "http://www.lulcards.com/images/iphone.png"
    invite_disabled false
    sent_timeline_alert_header "Post to Timeline"
    birthday_reminder_post_checkout_nag "lulcards make hilarious birthday gifts! Set up reminders to send cards to friends for their birthday. We'll look up their birthdays on Facebook."
    card_credits_nag_minimum_left_credits 30
    referral_credits 5
    sent_timeline_posts [
      {
        occasion: "none",
        alert: "Post on FIRST_NAME's timeline to let PRONOUN_OBJECT know you bought PRONOUN_OBJECT a card? (Don't worry, posting won't let PRONOUN_OBJECT see what your card looks like.)",
        caption: "I just sent you a printed photo in the mail with lulcards.",
        description: "It should arrive in the mail in 5-7 business days, keep your eyes out for it!",
      }, 
      {
        occasion: "reply",
        alert: "Post on FIRST_NAME's timeline to let PRONOUN_OBJECT know you bought PRONOUN_OBJECT a card? (Don't worry, posting won't let PRONOUN_OBJECT see what your card looks like.)",
        caption: "I just sent you back a card with lulcards.",
        description: "It should arrive in the mail in 5-7 business days, keep your eyes out for it!",
      }, 
      {
        occasion: "birthday",
        alert: "Post on FIRST_NAME's timeline to let PRONOUN_OBJECT know you bought PRONOUN_OBJECT a card? (Don't worry, posting won't let PRONOUN_OBJECT see what your card looks like.)",
        caption: "I just sent you a printed card in the mail for your birthday with lulcards.",
        description: "It should arrive in the mail 5-7 business days, keep your eyes out for it!",
      }, 
    ]

    facebook_connect_messages [
      { type: "recipient", message: "To choose your recipients you'll need to connect to Facebook.", force: true, force_nonintegrated: true, force_integrated: false, two_buttons_nonintegrated: true },
      { type: "friends_photos", message: "To view your friends' shared photos you'll need to connect to Facebook." },
      { type: "facebook_photos", message: "To view your Facebook photos you'll need to connect to Facebook." },
      { type: "send_message", message: "To send messages, you'll need to grant permission on Facebook." },
      { type: "post_tutorial", message: "Connect to use photos you and your friends have shared on Facebook.", force: true },
      { type: "share_card", message: "Share your cards on Facebook." },
    ]

    open_graph_share_enabled true
    open_graph_share_header "Share on Facebook"
    open_graph_share_message "Share your card after it arrives?"
    open_graph_share_delay_days 9
    open_graph_type "lulcards:card"
    open_graph_object "card"
    open_graph_endpoint "https://graph.facebook.com/me/lulcards:mail"
    recipient_sort_by_last_name false
    referral_credits 5
    order_submitted_invite_prompt_message "Thank you for your order. You can earn more credits to send free cards by inviting friends."
    ask_for_last_recipients true
    allow_lowercase_caption false
    processing_fee -1
    card_fee 125
    processing_credits 0
    card_credits 10

    credit_packages [
      { credit_package_id: 6, credits: 40, price: 475, savings: 5 },
      { credit_package_id: 7, credits: 90, price: 999, savings: 10 },
      { credit_package_id: 8, credits: 190, price: 1999, savings: 15 },
      { credit_package_id: 9, credits: 300, price: 2999, savings: 20 },
      { credit_package_id: 10, credits: 540, price: 4999, savings: 25 },
    ]
  end

  app "babygrams" do
    entity "babygram"
    mixpanel_token "6f1c33737007e79a8500d3ac57c1a95b"
    mixpanel_people_enabled false
    mixpanel_revenue_enabled false
    page_title "babygrams: send amazing baby photo postcards in the mail"
    page_tagline "Send amazing baby photo postcards in the mail."
    from_email "babygrams orders <orders@babygra.ms>"
    from_reminder_email "babygrams <support@babygra.ms>"
    from_thank_you_email "babygrams <support@babygra.ms>"
    facebook_app_id ENV["BABYCARDS_FB_API_KEY"]
    facebook_api_secret ENV["BABYCARDS_FB_API_SECRET"]
    fb_permissions ["email", "user_location", "user_photos", "user_relationships", "friends_photos", "friends_location", "friends_relationships"]
    fb_photo_permissions ["user_photos", "friends_photos"]
    fb_basic_permissions ["email"]
    fb_basic_photo_permissions ["user_photos"]
    fb_relationship_permissions ["user_relationships", "friends_relationships"]
    itunes_url "itms://itunes.apple.com/us/app/babygrams/id634710276?ls=1&mt=8"
    marketing_url "http://babygra.ms"
    kill_message "babygrams is unavailable."
    urban_airship_application_key ENV["BABYCARDS_URBAN_AIRSHIP_APP_KEY"]
    urban_airship_application_secret ENV["BABYCARDS_URBAN_AIRSHIP_APP_SECRET"]
    urban_airship_master_secret ENV["BABYCARDS_URBAN_AIRSHIP_MASTER_SECRET"]
    nag_version 2
    nag_app_versions ["1.0", "1.1", "1.1.1"]
    nag_title "New Version Available"
    nag_message "Babygrams 1.1.2 now available! This version fixes a number of bugs and crashing issues."
    nag_action "Update"
    nag_target "itms://itunes.apple.com/us/app/lulcards/id585112745?ls=1&mt=8"
    share_caption "Check out this card I got from NAME! #babygrams"
    invite_sms_message "I've been sending amazing baby photo postcards in the mail with babygrams, check it out! LINK"
    invite_sms_message_with_name "I've been using this app to mail printed pictures of FIRST_NAME from my phone, it's awesome! LINK"
    invite_share_message "#babygrams lets you send amazing baby photo postcards in the mail. check it out!"
    invite_url_prefix "http://babygramsapp.com/ref"
    invite_share_image "http://www.lulcards.com/images/iphone.png"
    invite_disabled false
    tutorial_postcard_line_1 "Mail a photo of your baby on a gorgeous printed postcard."
    tutorial_postcard_line_2 "Friends and relatives alike will love it!"
    subject_gender_info_line_1 "Tell us a bit about your new family member."
    subject_gender_info_line_2 "Our cards are personalized for your baby."
    subject_info_info_line_1 "Congratulations!"
    subject_info_info_line_2 "We'll include $$$ name and age on the babygrams that you send."
    subject_default_name_boy "(Ex. Michael Joseph)"
    subject_default_name_girl "(Ex. Mary Elizabeth)"
    subject_name_field_label "Your childs's first & middle name:"
    subject_birthday_field_label "@@@'s birthday:"

    tutorial_connect do
      variant 1, "tutor_button_verify", {
        nonintegrated: true,
        integrated: false,
        main_label: "",
        secondary_label: "Verify your name & e-mail with Facebook. Then, send a free babygram to try it out!",
        button_text: "Let's Go!"
      }
    end

    facebook_connect_messages [
        { type: "recipient", message: "Connect now to set up your account and send a *free* babygram!", force: true, force_nonintegrated: true, force_integrated: false, two_buttons_nonintegrated: false, two_buttons_integrated: false },
        { type: "friends_photos", message: "To view your friends' shared photos you'll need to grant access on Facebook." },
        { type: "facebook_photos", message: "To view your Facebook photos you'll need to grant access on Facebook." },
        { type: "send_message", message: "To send messages, you'll need to grant access on Facebook." },
        { type: "post_tutorial", message: "Connect to Facebook to set up your account. You'll earn 30 credits, enough to mail 3 free postcards!" },
        { type: "share_card", message: "Share your cards on Facebook." },
    ]

    card_credits_nag_minimum_left_credits 30
    open_graph_share_enabled true
    open_graph_share_header "Share on Facebook"
    open_graph_share_message "Do you want to share your babygram on Facebook?"
    open_graph_share_delay_days 0
    open_graph_type "sendbabycards:postcard"
    open_graph_object "postcard"
    open_graph_endpoint "https://graph.facebook.com/me/sendbabycards:mail"
    recipient_sort_by_last_name true
    referral_credits 10
    order_submitted_invite_prompt_message "Thank you for your order. You can earn more credits to send free cards by inviting other parents."
    ask_for_last_recipients true
    allow_lowercase_caption true
    min_baby_birthday_reminder_delay_days 10

    baby_birthday_reminder_recipient_placeholder "family and friends"

    baby_birthday_reminders [
      #{ weeks: 2, months: 0, notification: "FIRST is two weeks old today! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 2 weeks old!" },
      { weeks: 0, months: 1, notification: "One month old already? Mail a photo of FIRST to RECIPIENTS before PRONOUN grows up on you!", message: "I'm a month old!" },
      #{ weeks: 2, months: 1, notification: "FIRST is already six weeks! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 6 weeks old!" },
      { weeks: 0, months: 2, notification: "It's FIRST's 2 month birthday today! Mail a new photo to RECIPIENTS to mark the occasion.", message: "It's my 2 month birthday!" },
      #{ weeks: 2, months: 2, notification: "FIRST is already ten weeks! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 10 weeks old!" },
      { weeks: 0, months: 3, notification: "Three months old already? Mail a photo of FIRST to RECIPIENTS before PRONOUN grows up on you!", message: "I'm 3 months old!" },
      #{ weeks: 2, months: 3, notification: "FIRST is 14 weeks old today! Mail a photo to share the news with RECIPIENTS.", message: "I'm 14 weeks old!" },
      { weeks: 0, months: 4, notification: "It's FIRST's 4 month birthday! Mail a new photo to RECIPIENTS to mark the occasion.", message: "It's my 4 month birthday!" },
      #{ weeks: 2, months: 4, notification: "FIRST is already 18 weeks! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 18 weeks old!" },
      { weeks: 0, months: 5, notification: "FIRST is 5 months old today! Mail a photo to share the news with RECIPIENTS.", message: "I'm 5 months old!" },
      #{ weeks: 2, months: 5, notification: "FIRST is already 5 and a half months! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 22 weeks old!" },
      { weeks: 0, months: 6, notification: "FIRST is six months old! Mail a photo to RECIPIENTS for this big milestone.", message: "I'm 6 months old!" },
      #{ weeks: 2, months: 6, notification: "FIRST is already six and a half months! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 6 and 1/2 months old!" },
      { weeks: 0, months: 7, notification: "FIRST is 7 months old today! Mail a photo to share the news with RECIPIENTS.", message: "I'm 7 months old!" },
      { weeks: 0, months: 8, notification: "It's FIRST's 8 month birthday! Mail a new photo to RECIPIENTS to mark the occasion.", message: "It's my 8 month birthday!" },
      { weeks: 0, months: 9, notification: "Nine months old already? Mail a photo of FIRST to RECIPIENTS before PRONOUN grows up on you!", message: "I'm 9 months old!" },
      { weeks: 0, months: 10, notification: "FIRST is 10 months! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 10 months old!" },
      { weeks: 0, months: 11, notification: "FIRST is almost a year old! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 11 months old!" },
      { weeks: 0, months: 12, notification: "Happy 1st birthday to FIRST! Send a birthday photo to RECIPIENTS to mark this special day!", message: "Happy 1st birthday to me!" },
      { weeks: 0, months: 13, notification: "13 months already? Mail a photo of FIRST to RECIPIENTS before PRONOUN grows up on you!", message: "I'm 13 months old!" },
      { weeks: 0, months: 14, notification: "It's FIRST's 14 month birthday! Mail a new photo to RECIPIENTS to mark the occasion.", message: "It's my 14 month birthday!" },
      { weeks: 0, months: 15, notification: "15 months old already? Mail a photo of FIRST to RECIPIENTS before PRONOUN grows up on you!", message: "I'm 15 months old!" },
      { weeks: 0, months: 16, notification: "It's FIRST's 16 month birthday! Mail a new photo to RECIPIENTS to mark the occasion.", message: "It's my 16 month birthday!" },
      { weeks: 0, months: 17, notification: "FIRST is 17 months old today! Mail a photo to share the news with RECIPIENTS.", message: "I'm 17 months old!" },
      { weeks: 0, months: 18, notification: "FIRST is a year and half! Mail a photo to RECIPIENTS for this big milestone.", message: "I'm one and a half!" },
      { weeks: 0, months: 19, notification: "FIRST is 19 months! Mail a photo to share the news with RECIPIENTS.", message: "I'm 19 months old!" },
      { weeks: 0, months: 20, notification: "It's FIRST's 20 month birthday! Mail a new photo to RECIPIENTS to mark the occasion.", message: "It's my 20 month birthday!" },
      { weeks: 0, months: 21, notification: "21 months already? Mail a photo of FIRST to RECIPIENTS before PRONOUN grows up on you!", message: "I'm 21 months old!" },
      { weeks: 0, months: 22, notification: "FIRST is 22 months old today! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 22 months old!" },
      { weeks: 0, months: 23, notification: "FIRST is almost two! Mail a photo to share this milestone with RECIPIENTS.", message: "I'm 23 months old!" },
      { weeks: 0, months: 24, notification: "Happy 2nd birthday to FIRST! Send a birthday photo to RECIPIENTS to mark this special day!", message: "Happy 2nd birthday to me!" },
    ]

    reminder_app_url "babycards://reminder"
    baby_birthday_reminder_switch "Remind me to share milestones"
    baby_birthday_remind_when_no_credits true
    processing_fee -1
    card_fee 150
    processing_credits 0
    card_credits 10

    credit_packages [
      { credit_package_id: 96, credits: 70, price: 949, savings: 10 },
      { credit_package_id: 97, credits: 160, price: 1999, savings: 15 },
      { credit_package_id: 99, credits: 450, price: 4999, savings: 25 },
    ]

    frame_types "all"
  end

  recipient_suggested_table_header "Relatives:"
  recipient_suggested_expiration_days 30

  preorder_credit_nag({
    enabled: true,
    title: "Refill Credits",
    message_no_credits: "You have no credits left! You can pay as you go for just $1.49 per card, or refill your credits to save up to 25%.",
    message_some_credits: "You only have CREDITS credits left! You can pay as you go for just $1.49 per card, or refill your credits to save up to 25%.",
    refill_button: "Refill Now",
    cancel_button: "Pay As I Go",
  })

  green_buy_button_disabled false

  suggested_recipients_enabled true
  suggested_recipients_non_retina 16
  suggested_recipients_retina 24

  share_dialog_type "preview_full"

  contact_recipients_enabled true

  if Rails.env == "development"
    qr_path "http://posto.dev/qr/"
    share_url_path "http://posto.dev/v/"
  else
    qr_path "http://lulcards.com/qr/"

    app "lulcards" do
      share_url_path "http://lulcards.com/v/"
    end

    app "babygrams" do
      share_url_path "http://babygramsapp.com/v/"
    end
  end

  api_key_expiration_days 30
  api_key_renewal_days 15

  order_workflow_version "2.2"
  birthday_request_workflow_version "2.1"
  outgoing_email_workflow_version "2.3"

  effects true
  caption_swap_button false
  number_of_clicks_before_tooltip 1
  design_edit_hint_mode "tooltip"
  server_debug false
  fb_message_permissions ["read_mailbox", "xmpp_login"]
  fb_share_permissions ["publish_actions"]
  fb_fields ["gender", "birthday"]

  signup_credits 10
  signup_credits_title "You Have CREDITS Credits"
  signup_credits_message "You now have CREDITS credits and can send a free card!"
  max_cards_to_send 9
  max_photo_byte_size 24 * 1024 * 1024
  recipient_address_expiration_days 31 * 6
  address_request_expiration_days 6
  birthday_request_expiration_days 6
  cvc_enabled false
  min_birthday_days 0
  max_birthday_days 14
  birthday_nag "Send a surprise birthday lulcard."
  note_max_length 120 
  facebook_prompt_post_tutorial true
  default_notes [ { occasion: "birthday", note: "Happy birthday!" } ]

  order_submitted_header "Thanks!"
  order_submitted_message "Your order has been submitted. We'll notify and e-mail you as we process it."
  order_submitted_credit_prompt_header "Thanks!"
  order_submitted_credit_prompt_message "Thank you for your order. You can save up to 25% by refilling your credits."
  order_submitted_credit_prompt_cancel_action "Not Now"
  order_submitted_credit_prompt_action "Refill Now"
  order_submitted_invite_prompt_header "Earn Free Credits"
  order_submitted_invite_prompt_cancel_action "No Thanks"
  order_submitted_invite_prompt_action "Earn Credits"

  credit_order_submitted_header "Thanks!"
  credit_order_submitted_message "CREDITS credits have been added to your account. You now have TOTAL credits."

  shuffle_captions true

  card_io true

  permission_caption "Chat and Inbox access is needed to ask your friends for their addresses."

  facebook_allow_messages do
    variant 1, "hey want send", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send a message or enter it yourself.",
      message: "hey what's your mailing address, i want to send you something\n",
      disclaimer: "\n\nWe'll mail $$$ card once %%% responds.",
      title: "!!!",
      button_label: "Send",
      known_address_label: "I know @@@'s address",
    }

    variant 1, "hey short", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send a message or enter it yourself.",
      message: "hey what's your mailing address?\n\n",
      disclaimer: "\n\nWe'll mail $$$ card once %%% responds.",
      title: "!!!",
      button_label: "Send",
      known_address_label: "I know @@@'s address",
    }

    variant 1, "hey where", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send a message or enter it yourself.",
      message: "hey I want to mail you something, what's your mailing address?\n",
      disclaimer: "\n\nWe'll mail $$$ card once %%% responds.",
      title: "!!!",
      button_label: "Send",
      known_address_label: "I know @@@'s address",
    }
  end

  facebook_address_birthday_allow_messages do
    variant 1, "hey birthday card", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send ### a Facebook message.",
      message: "hey I want to mail you a birthday card, what's your mailing address?\n",
      disclaimer: "This message will only be sent if you buy @@@ a card. We will mail $$$ card to the address %%% responds with.",
      title: "!!!",
      button_label: "Send",
      known_address_label: "I know @@@'s address",
    }
  end

  facebook_birthday_allow_messages do
    variant 1, "hey setting up", {
      header_primary: "@@@'s birthday\nisn't on Facebook.",
      header_secondary: "Send ### a message to ask.",
      message: "hey when's your birthday?\n\n",
      disclaimer: "This message will be sent if you set a birthday reminder for @@@. We'll notify you when %%% responds.",
      title: "!!!",
      button_label: "Send",
      known_address_label: "I know @@@'s birthday",
    }
  end

  birthday_reminder_recipient_prompt "Choose who you'll send birthday cards to."
  birthday_reminder_days 9
  birthday_reminder_buy_info_text "You'll get a reminder 7 days before their birthday."
  birthday_reminder_message "NAME's birthday is on DATE! Mail a card now for PRONOUN_OBJECT to get it in time."
  birthday_reminder_hour 12
  birthday_reminder_minute 30
  birthday_reminder_version 1
  birthday_reminder_update_message "Your birthday reminders have been updated. You now have NUMBER reminders."
  birthday_reminder_post_checkout_nag_header "Set Reminders"
  birthday_reminder_post_checkout_nag_action "Set Up"
  birthday_reminder_post_checkout_nag_when_empty true
  birthday_reminder_post_checkout_nag_on_birthday true

  default_captions [
      "lol", "haha", "lulz", "sup", "wat", "oh hai", "wtf", "fail", "yolo", "nope", "meh", "woof",
      "soon.", "uh no", "win", "douche", "fuuuuu", "fuck yea", "zomg", "fml", "derp", "dat ass", "ohshi",
      "fuck it", "pwned", "what is this i don't even", "not bad", "o rly?", "mother of god", "dafuq",
      "like a boss", "shit just got real", "u mad?", "cool story bro", "sucks to suck", "haters gonna hate",
      "seems legit", "i have no idea what i'm doing", "whatcha thinkin bout?", "oh god why", "its a trap",
      "bitch please", "i am not good with computer",
  ]

  memes_enabled true

  stock_designs({
    memes: [
      {  
        id: "first_world_problems", 
        name: "First World Problems",
        thumb: "http://d1vgp5rbple5yc.cloudfront.net/memes/thumb/first_world_problems.jpg",
        image: "http://d19ku6gs1135cx.cloudfront.net/cd/87/74/cd877458aa6f7e9b92fa885942d974b6.jpg",
        captions: [
          { top_caption: "i had something clever to say", bottom_caption: "but the conversation has moved on", top_font_size: 24, bottom_font_size: 18 },
          { top_caption: "i dropped my iphone", bottom_caption: "on my ipad", top_font_size: 30, bottom_font_size: 36 },
          { top_caption: "i ordered delivery", bottom_caption: "now i have to put on clothes", top_font_size: 30, bottom_font_size: 24 },
          { top_caption: "i can't access the internet", bottom_caption: "from the toilet", top_font_size: 24, bottom_font_size: 30 },
          { top_caption: "i started watching a new TV show", bottom_caption: "now i have to wait for new episodes", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "i'm so thirsty", bottom_caption: "but there's nothing to drink except free water", top_font_size: 30, bottom_font_size: 18 },
          { top_caption: "it's my birthday", bottom_caption: "but i already have everything i want", top_font_size: 30, bottom_font_size: 18 },
        ] 
      },
      {  
        id: "bad_luck_billy", 
        name: "Bad Luck Billy",
        thumb: "http://d1vgp5rbple5yc.cloudfront.net/memes/thumb/bad_luck_billy.jpg",
        image: "http://d19ku6gs1135cx.cloudfront.net/c2/37/9f/c2379fc824e79961065d9f097c6408eb.jpg",
        captions: [
          { top_caption: "checks back seat of car for murderer", bottom_caption: "yup", top_font_size: 18, bottom_font_size: 72 },
          { top_caption: "uses bathroom at girlfriend's parents' house", bottom_caption: "no plunger", top_font_size: 24, bottom_font_size: 36 },
          { top_caption: "has lots of friend requests on facebook", bottom_caption: "relatives", top_font_size: 24, bottom_font_size: 36 },
          { top_caption: "finally beats friends in competitive sport", bottom_caption: "bowling", top_font_size: 18, bottom_font_size: 42 },
          { top_caption: "works up courage to say \"i love you\"", bottom_caption: "to the dog", top_font_size: 18, bottom_font_size: 36 },
          { top_caption: "realizes dream of appearing on tv singing competition", bottom_caption: "sucks", top_font_size: 18, bottom_font_size: 54 },
          { top_caption: "family vacation to disneyland", bottom_caption: "china", top_font_size: 24, bottom_font_size: 54 },
          { top_caption: "parents finally agree to buy him a pet", bottom_caption: "rock", top_font_size: 18, bottom_font_size: 54 },
          { top_caption: "dreams of becoming a lawyer", bottom_caption: "becomes a defendant", top_font_size: 18, bottom_font_size: 36 },
        ] 
      },
      {  
        id: "success_baby", 
        name: "Success Baby",
        thumb: "http://d1vgp5rbple5yc.cloudfront.net/memes/thumb/success_baby.jpg",
        image: "http://d19ku6gs1135cx.cloudfront.net/16/90/be/1690be1f103a61dde7f20528843e7265.jpg",
        captions: [
          { top_caption: "overslept for work", bottom_caption: "daylight savings time", top_font_size: 24, bottom_font_size: 24 },
          { top_caption: "ran into high school bully", bottom_caption: "\"would you like fries with that?\"", top_font_size: 24, bottom_font_size: 18 },
          { top_caption: "crazy night of drinking", bottom_caption: "still have phone and wallet", top_font_size: 30, bottom_font_size: 18 },
          { top_caption: "made a wrong turn", bottom_caption: "shortcut", top_font_size: 30, bottom_font_size: 36 },
          { top_caption: "did load of laundry", bottom_caption: "all socks accounted for", top_font_size: 30, bottom_font_size: 24 },
          { top_caption: "video conference call", bottom_caption: "pants optional", top_font_size: 18, bottom_font_size: 30 },
          { top_caption: "don't remember last night", bottom_caption: "have lots of new friends", top_font_size: 24, bottom_font_size: 24 },
          { top_caption: "she dumped me", bottom_caption: "two days before her birthday", top_font_size: 24, bottom_font_size: 24 },
        ] 
      },
      {  
        id: "confession_grizzly", 
        name: "Confession Grizzly",
        thumb: "http://d1vgp5rbple5yc.cloudfront.net/memes/thumb/confession_grizzly.jpg",
        image: "http://d19ku6gs1135cx.cloudfront.net/ad/a4/3d/ada43d5a85218e27fb81a48ceebf5278.jpg",
        captions: [
          { top_caption: "i pretend to be stupid", bottom_caption: "so i don't have to answer dumb questions", top_font_size: 30, bottom_font_size: 18 },
          { top_caption: "i am a hero when trouble strikes", bottom_caption: "in my imagination", top_font_size: 18, bottom_font_size: 30 },
          { top_caption: "i can keep a secret", bottom_caption: "until someone asks me about it", top_font_size: 30, bottom_font_size: 18 },
          { top_caption: "i'm a vegetarian", bottom_caption: "with a weakness for bacon", top_font_size: 30, bottom_font_size: 24 },
          { top_caption: "i use big words", bottom_caption: "if i think you won't know what they mean", top_font_size: 30, bottom_font_size: 18 },
          { top_caption: "i replay conversations in my head", bottom_caption: "five years after they happened", top_font_size: 24, bottom_font_size: 24 },
          { top_caption: "i get paid lots of money", bottom_caption: "to surf the internet all day", top_font_size: 24, bottom_font_size: 24 },
          { top_caption: "people think i am intelligent", bottom_caption: "i just know about wikipedia", top_font_size: 24, bottom_font_size: 18 },
          { top_caption: "i got your text", bottom_caption: "i just didn't want to respond", top_font_size: 30, bottom_font_size: 18 },
        ] 
      },
      {  
        id: "most_interesting_man", 
        name: "Interesting Man",
        thumb: "http://d1vgp5rbple5yc.cloudfront.net/memes/thumb/most_interesting_man.jpg",
        image: "http://d19ku6gs1135cx.cloudfront.net/78/09/04/78090499c61c9efaf5f47e4c61d6e2bf.jpg",
        captions: [
          { top_caption: "i don't always play video games", bottom_caption: "but when I do, I disappear from society and subsist on junk food", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "i don't always post photos on facebook", bottom_caption: "but when i do, i offend friends and family alike", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "i don't always find music i like", bottom_caption: "but when i do, i play it until it induces vomiting", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "i don't always wear a suit", bottom_caption: "but when i do, i have to google how to tie a tie properly", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "i don't always curse at other drivers", bottom_caption: "but when i do, it was probably my fault", top_font_size: 18, bottom_font_size: 24 },
          { top_caption: "i don't always read the instructions on toiletries", bottom_caption: "but when i do, it's because i forgot my phone when i went to the bathroom", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "i don't always leave my dog's turds on the side of the road", bottom_caption: "but when i do, it's because I think nobody is around to witness the crime", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "i don't always use the word \"ergo\"", bottom_caption: "but when I do, I'm losing the argument", top_font_size: 18, bottom_font_size: 24 },
          { top_caption: "i don't always reply to people with \"with all due respect\"", bottom_caption: "but when i do, I'm about to insult your mother", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "i don't always watch football", bottom_caption: "but when I do, it's the Super Bowl", top_font_size: 18, bottom_font_size: 24 },
        ] 
      },
      {  
        id: "half_baked_bart", 
        name: "Half Baked Bart",
        thumb: "http://d1vgp5rbple5yc.cloudfront.net/memes/thumb/half_baked_bart.jpg",
        image: "http://d19ku6gs1135cx.cloudfront.net/9e/2c/fe/9e2cfe2a9e280420544b9d334f633a02.jpg",
        captions: [
          { top_caption: "officer i'm sorry i ran the light", bottom_caption: "i thought it was blue", top_font_size: 18, bottom_font_size: 30 },
          { top_caption: "how would you like your steak cooked?", bottom_caption: "extra large", top_font_size: 18, bottom_font_size: 30 },
          { top_caption: "you know what's faster than the speed of light?", bottom_caption: "the speed of love", top_font_size: 18, bottom_font_size: 30 },
          { top_caption: "hey look a sheep", bottom_caption: "moooo", top_font_size: 30, bottom_font_size: 54 },
          { top_caption: "a bath is like", bottom_caption: "an instant shower", top_font_size: 24, bottom_font_size: 30 },
        ] 
      },
      {  
        id: "condescending_wally", 
        name: "Condescending Wally",
        thumb: "http://d1vgp5rbple5yc.cloudfront.net/memes/thumb/condescending_wally.jpg",
        image: "http://d19ku6gs1135cx.cloudfront.net/11/87/a2/1187a2969943221844b1105e8bfca1c5.jpg",
        captions: [
          { top_caption: "You wear a weatherproof outdoors jacket?", bottom_caption: "Tell me about your last adventure.", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "You have a pinstripe on your car?", bottom_caption: "It must make it go so much faster.", top_font_size: 18, bottom_font_size: 24 },
          { top_caption: "You read the book the movie is based on?", bottom_caption: "You must be so much more worthy of seeing it than everyone else.", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "You found your soul mate?", bottom_caption: "Who is it this month?", top_font_size: 24, bottom_font_size: 30 },
          { top_caption: "You post pictures with filters on the internet?", bottom_caption: "How long have you been a photographer?", top_font_size: 18, bottom_font_size: 24 },
          { top_caption: "You have political bumper stickers?", bottom_caption: "You must have deep and nuanced opinions.", top_font_size: 18, bottom_font_size: 18 },
          { top_caption: "You changed your oil?", bottom_caption: "You must be a real gearhead.", top_font_size: 30, bottom_font_size: 24 },
        ] 
      },
      {  
        id: "scumbag_data_scientist", 
        name: "Scumbag Data Scientist",
        thumb: "http://d1vgp5rbple5yc.cloudfront.net/memes/thumb/scumbag_data_scientist.jpg",
        image: "http://d19ku6gs1135cx.cloudfront.net/f5/6c/35/f56c352e1562014c6257d03825abbcef.jpg",
        captions: [
          { top_caption: "forgets break statement", bottom_caption: "runs $10,000 map reduce job", top_font_size: 24, bottom_font_size: 24 },
          { top_caption: "pulls idea out of ass", bottom_caption: "calls it 'hypothesis'", top_font_size: 30, bottom_font_size: 30 },
          { top_caption: "understands 3rd normal form", bottom_caption: "fuck it. mongodb", top_font_size: 18, bottom_font_size: 36 },
          { top_caption: "phd in statistics", bottom_caption: "buys you a lotto ticket for your birthday", top_font_size: 30, bottom_font_size: 18 },
          { top_caption: "successfully applies latent dirichlet allocation", bottom_caption: "to improve ad targeting", top_font_size: 18, bottom_font_size: 24 },
        ] 
      },
    ]
  })

end
