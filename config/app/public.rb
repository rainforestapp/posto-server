require "sampleable_config"

CONFIG = SampleableConfig.define do
  version 1
  kill_switch false
  really_kill_switch false
  mixpanel_enabled true
  mixpanel_people_enabled true
  mixpanel_event_screen []
  kill_message "Lulcard is unavailable."
  support_email "support@lulcards.com"
  uservoice_enabled true
  testflight_enabled true
  itunes_url "itms://itunes.apple.com/us/app/lulcards/id585112745?ls=1&mt=8"

  card_image_host "data.lulcards.com"
  card_image_bucket "posto-data"

  csv_host "d19ku6gs1135cx.cloudfront.net"
  csv_bucket "posto-data"

  facebook_app_id "487965654580467"

  if Rails.env == "development"
    qr_path "http://posto.dev/qr/"
    share_url_path "http://posto.dev/v/"
  else
    qr_path "http://lulcards.com/qr/"
    share_url_path "http://lulcards.com/v/"
  end

  api_key_expiration_days 30
  api_key_renewal_days 15

  order_workflow_version "2.1"

  effects true
  caption_swap_button false
  number_of_clicks_before_tooltip 1
  design_edit_hint_mode "tooltip"
  server_debug false
  fb_permissions ["email", "read_mailbox", "xmpp_login", "user_location", "friends_location", "user_photos", "friends_photos"]
  fb_message_permissions ["read_mailbox", "xmpp_login"]
  fb_fields ["gender", "birthday"]
  processing_fee 100
  card_fee 99
  processing_credits 5
  card_credits 5
  referral_credits 5
  signup_credits 30
  signup_credits_title "You Earned CREDITS Credits"
  signup_credits_message "You earned CREDITS credits by connecting your Facebook account to lulcards!"
  max_cards_to_send 9
  max_photo_byte_size 24 * 1024 * 1024
  recipient_address_expiration_days 31 * 6
  address_request_expiration_days 6
  cvc_enabled false
  stripe_publishable_key ENV["STRIPE_PUBLISHABLE_KEY"]
  nag_version 1
  nag_app_versions ["1.0", "1.0.1"]
  nag_title "New Version Available"
  nag_message "A new version of lulcards is available."
  nag_action "Update"
  nag_target "itms://itunes.com/apps/instagram"

  order_submitted_header "Thanks!"
  order_submitted_message "Your order has been submitted. We'll notify and e-mail you as we process it."
  order_submitted_credit_prompt_header "Thanks!"
  order_submitted_credit_prompt_message "Thank you for your order. You can save up to 25% on your next order using credits. Want to know more?"
  order_submitted_credit_prompt_cancel_action "No Thanks"
  order_submitted_credit_prompt_action "Learn More"

  credit_order_submitted_header "Thanks!"
  credit_order_submitted_message "CREDITS credits have been added to your account. You now have TOTAL credits."

  credit_packages [
    { credit_package_id: 1, credits: 50, price: 939, savings: 5 },
    { credit_package_id: 2, credits: 110, price: 1949, savings: 10 },
    { credit_package_id: 3, credits: 300, price: 4999, savings: 15 },
    { credit_package_id: 4, credits: 630, price: 9999, savings: 20 },
    { credit_package_id: 5, credits: 1350, price: 19999, savings: 25 },
  ]

  shuffle_captions do
    variant 1, true
    variant 1, false
  end

  share_caption "Check out this postcard I got from NAME! #lulcards"
  invite_sms_message "I've been sending hilarious postcards to people with lulcards, check it out! LINK"
  invite_share_message "#lulcards lets you send hilarious postcards to friends. check it out!"
  invite_url_prefix "http://lulcards.com/ref"
  invite_share_image "http://www.lulcards.com/images/iphone.png"
  invite_disabled false

  card_io do
    variant 1, true
    variant 2, false
  end

  permission_caption do
    variant 1, "is_needed", "Chat and Inbox access is needed to ask your friends for their addresses."
    variant 1, "is_needed_spam", "Access is used to ask for addresses.\nWe promise we won't spam."
    variant 1, "without_asking", "We'll never post anything to Facebook without asking first."
    #
    #variant 1, "we_need_you", "We need access so you can ask your friends for their addresses."
    #variant 1, "we_need_us", "We need permission to ask your friends for their addresses. We won't spam."
    #variant 1, "we_need_tell", "We need Chat & Inbox permissions so your friends can provide their addresses."
    #variant 1, "lets_you_ask", "Chat & Inbox permissions let you ask for your friends' addresses."
    #variant 1, "we_send", "We send Facebook messages to ask for addresses. We promise we won't spam."
  end

  facebook_allow_messages do
    variant 1, "hey want send", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send ### a Facebook message.",
      message: "hey what's your mailing address, i want to send you something\n",
      disclaimer: "This message will only be sent if you buy @@@ a card. We will mail $$$ card to the address %%% responds with.",
      title: "!!!",
      button_label: "Send",
      known_address_label: "I know @@@'s address",
    }

    variant 1, "hey short", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send ### a Facebook message.",
      message: "hey what's your mailing address?\n\n",
      disclaimer: "This message will only be sent if you buy @@@ a card. We will mail $$$ card to the address %%% responds with.",
      title: "!!!",
      button_label: "Send",
      known_address_label: "I know @@@'s address",
    }

    variant 1, "hey where", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send ### a Facebook message.",
      message: "hey I want to mail you something, what's your mailing address?\n",
      disclaimer: "This message will only be sent if you buy @@@ a card. We will mail $$$ card to the address %%% responds with.",
      title: "!!!",
      button_label: "Send",
      known_address_label: "I know @@@'s address",
    }
  end

  default_captions do
    variant 1, "many", [
      "lol", "haha", "lulz", "sup", "wat", "oh hai", "wtf", "fail", "yolo", "nope", "meh", "woof",
      "soon.", "uh no", "win", "douche", "fuuuuu", "fuck yea", "zomg", "fml", "derp", "dat ass", "ohshi",
      "fuck it", "pwned", "what is this i don't even", "not bad", "o rly?", "mother of god", "dafuq",
      "like a boss", "shit just got real", "u mad?", "cool story bro", "sucks to suck", "haters gonna hate",
      "seems legit", "i have no idea what i'm doing", "whatcha thinkin bout?", "oh god why", "its a trap",
      "bitch please", "i am not good with computer",
    ]

    variant 1, "few", [
      "lulz", "sup", "wat", "wtf", "fail", "yolo", "nope", "meh", "woof",
      "win", "douche", "fuuuuu", "fuck yea", "fml", "derp", "dat ass", "meh", 
      "fuck it", "pwned", "not bad", "mother of god", "dafuq",
      "like a boss", "shit just got real", "cool story bro", 
      "seems legit", "bitch please", 
    ]
  end

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
          { top_caption: "ran into high school bully", bottom_caption: ""would you like fries with that?"", top_font_size: 24, bottom_font_size: 18 },
          { top_caption: "crazy night of drinking", bottom_caption: "still have phone and wallet", top_font_size: 30, bottom_font_size: 18 },
          { top_caption: "made a wrong turn", bottom_caption: "shortcut", top_font_size: 30, bottom_font_size: 36 },
          { top_caption: "did load of laundry", bottom_caption: "all socks accounted for", top_font_size: 30, bottom_font_size: 24 },
          { top_caption: "video conference call", bottom_caption: "pants optional", top_font_size: 18, bottom_font_size: 30 },
          { top_caption: "don't remember last night", bottom_caption: "have lots of new friends", top_font_size: 24, bottom_font_size: 24 },
          { top_caption: "she dumped me", bottom_caption: "two days before her birthday", top_font_size: 24, bottom_font_size: 24 },
        ] 
      },
    ]
  })
end
