class QrController < ApplicationController
  def show
    uid = params[:id][1..-1]
    type = params[:id][0]

    position = nil
    case type
    when "f"
      position = :front
    when "b" 
      position = :back
    else
      raise "Bad id #{params[:id]}"
    end

    card_printing = CardPrinting.where(uid: uid).first
    card_order = card_printing.card_order
    card_design = card_order.card_design
    preview_composition = card_design.card_preview_composition
    sender = card_order.order_sender_user

    out = {}
    out[:sender] = {
      user_id: sender.user_id,
      facebook_id: sender.facebook_id,
      name: sender.user_profile.name,
    }

    out[:sent_on] = card_order.created_at.strftime("%-m/%-d/%y")

    out[:images] = {
      treated_preview: preview_composition.treated_card_preview_image.public_url,
      preview: preview_composition.card_preview_image.public_url,
      original_full_photo: card_design.original_full_photo_image.public_url,
    }

    if card_design.edited_full_photo_image
      out[:images][:edited_full] = card_design.edited_full_photo_image.public_url
    end

    render json: out
  end
end

