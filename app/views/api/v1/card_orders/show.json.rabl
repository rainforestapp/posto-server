object @card_order

attributes :card_order_id, :order_sender_user_id, :state, :app_id, :created_at

node(:share_uid) do |card_order|
  "f" + (card_order.card_printings.first.try(:uid) || "")
end

node(:created_ago) do |card_order|
  time_ago_in_words card_order.created_at
end

node(:card_printing_image) do |card_order|
  { url: card_order.card_printings.first.card_printing_composition.try(:jpg_card_front_image).try(:public_url) }
end

child :card_design do
  attributes :top_caption, :bottom_caption, :top_caption_font_size, :bottom_caption_font_size, :postcard_subject, :frame_type, :photo_taken_at

  [:original_full_photo_image, :edited_full_photo_image, :composed_full_photo_image].each do |image|
    node(image) do |design|
      { url: design.send(image).try(:public_url) }
    end
  end

  [:card_preview_image, :treated_card_preview_image].each do |image|
    node(image) do |design|
      { url: design.card_preview_composition.send(image).try(:public_url) }
    end
  end
end

child :card_printings do
  attributes :recipient_user_id

  [:first_name, :last_name, :name].each do |attribute|
    node(attribute) do |printing|
      printing.recipient_user.user_profile.try(attribute)
    end
  end

  node(:client_id) do |printing|
    printing.recipient_user.facebook_id
  end
end
