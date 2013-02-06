require "config_hash"
c = CONFIG = ConfigHash.new

c.api_key_expiration_days = 30
c.api_key_renewal_days = 15
c.effects = true
c.number_of_clicks_before_tooltip = 1
c.design_edit_hint_mode = "tooltip"
c.tap_to_edit_top_caption = "tap to edit"
c.tap_to_edit_bottom_caption = "scroll for more"
c.debug = true
c.permission_caption = "Chat and Inbox access is needed to ask your recipients for their addresses."
c.fb_permissions = ["email", "read_mailbox", "xmpp_login", "friends_location", "user_location"]
c.processing_fee = 99
c.card_fee = 100

c.facebook_allow_messages = {
  header_primary: "We need to verify\n@@@'s address.",
  header_secondary: "Send ### a Facebook message.",
  message: "hey, I want to mail you a postcard I made with an app called lulcards. what's your address?",
  disclaimer: "This message will only be sent if you buy @@@ a card. We will mail $$$ card to the address %%% responds with.",
  title: "!!!",
  button_label: "Send",
}

c.max_cards_to_send = 9

c.default_captions = [
  "lol", "haha", "lulz", "sup", "wat", "oh hai", "wtf", "fail", "yolo", "nope", "meh", "woof",
  "soon.", "win", "douche", "fuuuuu", "fuck yea", "zomg", "fml", "derp", "dat ass", "meh", "ohshi",
  "fuck it", "pwned", "what is this i don't even", "not bad", "o rly?", "mother of god", "dafuq",
  "like a boss", "shit just got real", "u mad?", "cool story bro", "sucks to suck", "haters gonna hate",
  "seems legit", "i have no idea what i'm doing", "whatcha thinkin bout?", "oh god why", "its a trap",
  "bitch please", "i am not good with computer",
]
