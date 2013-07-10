object @card_order

attributes :card_order_id, :state, :app_id, :created_at

note(:created_ago) do |card_order|
  card_order.created_at.time_ago_in_words
end

child :card_design do
  attributes :top_caption, :bottom_caption, :top_caption_font_size, :bottom_caption_fnt_size, :postcard_subject

  [:original_full_photo_image, :edited_full_photo_image, :composed_full_photo_image].each do |image|
    node(image) do |design|
      { public_url: design.send(image).try(:public_url),
        public_ssl_url: design.send(image).try(:public_ssl_url) }
    end
  end

  [:card_preview_image, :treated_card_preview_image].each do |image|
    node(image) do |design|
      { public_url: design.card_preview_composition.send(image).try(:public_url),
        public_ssl_url: design.card_preview_composition.send(image).try(:public_ssl_url) }
    end
  end
end

child :card_printings do
  [:first_name, :last_name, :name].each do |attribute|
    node(attribute) do |printing|
      printing.recipient_user.user_profile.try(attribute)
    end
  end

  node(:client_id) do |printing|
    printing.recipient_user.facebook_id
  end
end
