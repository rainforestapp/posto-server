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
  signup_credits 30
  max_cards_to_send 9
  max_photo_byte_size 24 * 1024 * 1024
  recipient_address_expiration_days 31 * 6
  address_request_expiration_days 6
  cvc_enabled false
  stripe_publishable_key ENV["STRIPE_PUBLISHABLE_KEY"]
  nag_version 1
  nag_title "New Version Available"
  nag_message "A new version of lulcards is available."
  nag_action "Update"
  nag_target "itms://itunes.com/apps/instagram"

  order_submitted_header "Thanks!"
  order_submitted_message "Your order has been submitted. We'll notify and e-mail you as we process it."

  shuffle_captions do
    variant 1, true
    variant 1, false
  end

  share_caption "Check out this postcard I got from NAME! #lulcards"

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
      message: "hey I want to mail you something, what's your address?\n",
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
end
