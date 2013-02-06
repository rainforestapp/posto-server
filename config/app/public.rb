require "sampleable_config"

CONFIG = SampleableConfig.define do
  api_key_expiration_days 30
  api_key_renewal_days 15

  effects true
  number_of_clicks_before_tooltip 1
  design_edit_hint_mode "tooltip"
  tap_to_edit_top_caption "tap to edit"
  tap_to_edit_bottom_caption "scroll for more"
  server_debug false
  fb_permissions ["email", "read_mailbox", "xmpp_login", "friends_location", "user_location"]
  processing_fee 99
  card_fee 100
  max_cards_to_send 9
  max_photo_byte_size 24 * 1024 * 1024

  shuffle_captions do
    variant 1, true
    variant 1, false
  end

  permission_caption do
    variant 1, "needed", "Chat and Inbox access is needed to ask your recipients for their addresses."
    variant 1, "used", "Chat and Inbox access is used to ask your recipients for their addresses."
    variant 1, "required", "Chat and Inbox permissions are required to ask your recipients for their addresses."
  end

  facebook_allow_messages do
    variant 1, "hey want lulcards", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send ### a Facebook message.",
      message: "hey, I want to mail you a postcard I made with an app called lulcards. what's your address?",
      disclaimer: "This message will only be sent if you buy @@@ a card. We will mail $$$ card to the address %%% responds with.",
      title: "!!!",
      button_label: "Send",
    }

    variant 1, "hey want", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send ### a Facebook message.",
      message: "hey, I want to mail you a postcard. what's your address?\n",
      disclaimer: "This message will only be sent if you buy @@@ a card. We will mail $$$ card to the address %%% responds with.",
      title: "!!!",
      button_label: "Send",
    }

    variant 1, "hey address", {
      header_primary: "We need to verify\n@@@'s address.",
      header_secondary: "Send ### a Facebook message.",
      message: "hey, what's your address?\n\n",
      disclaimer: "This message will only be sent if you buy @@@ a card. We will mail $$$ card to the address %%% responds with.",
      title: "!!!",
      button_label: "Send",
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
