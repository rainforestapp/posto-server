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

    out = {}
    out[:sender_name] = card_order.order_sender_user.user_profile.name
    out[:sent_on] = card_order.created_at.strftime("%-m/%-d/%y")
    out[:treated_preview_image_url] = preview_composition.treated_card_preview_image.public_url
    out[:preview_image_url] = preview_composition.card_preview_image.public_url
    out[:original_full_photo_url] = card_design.original_full_photo_image.public_url

    if card_design.edited_full_photo_image
      out[:edited_full_photo_url] = card_design.edited_full_photo_image.public_url
    end

    render json: out
  end
end

