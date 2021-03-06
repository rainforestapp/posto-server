class QrController < ApplicationController
  include ApiSecureEndpoint 

  allow_unauthenticated_access!

  def show
    uid = params[:id][1..-1]
    type = params[:id][0]

    unless params[:id]
      head :bad_request
      return
    end

    device_uuid = params[:device_uuid]

    position = nil
    case type
    when "f"
      position = :front
    when "b" 
      position = :back
    else
      head :bad_request
      return
    end

    card_printing = CardPrinting.where(uid: uid).first

    unless card_printing
      head :bad_request
      return
    end

    card_order = card_printing.card_order
    printing_composition = card_printing.card_printing_composition
    card_design = card_order.card_design
    preview_composition = card_design.card_preview_composition
    sender = card_order.order_sender_user

    bind_to_app!(card_order.app)

    if @current_user || !device_uuid.blank?
      user_id = @current_user.try(:user_id)

      is_first_scan = card_printing.card_scan.nil?

      card_scan = card_printing.card_scans.create!(
        device_uuid: device_uuid,
        scanned_by_user_id: user_id,
        scanned_at: Time.zone.now,
        app_id: card_order.app_id,
        scan_position: position,
      )

      card_scan.send_notification! if is_first_scan
    end

    respond_to do |format|
      format.json do
        out = {}

        out[:sender] = {
          user_id: sender.user_id,
          facebook_id: sender.facebook_id,
          name: sender.user_profile.name,
          first_name: sender.user_profile.first_name,
        }

        out[:sent_on] = card_order.created_at.strftime("%-m/%-d/%y")
        out[:share_url] = @config.share_url_path + params[:id]

        out[:images] = {
          treated_preview: preview_composition.treated_card_preview_image.public_url,
          preview: preview_composition.card_preview_image.public_url,
          original_full_photo: card_design.original_full_photo_image.public_url,
          composed: printing_composition.jpg_card_front_image.public_url
        }

        out[:design] = {
          top_caption: card_design.top_caption,
          top_caption_font_size: card_design.top_caption_font_size.to_i,
          bottom_caption: card_design.bottom_caption,
          bottom_caption_font_size: card_design.bottom_caption_font_size.to_i,
          stock_design_id: card_design.stock_design_id,
        }

        if card_design.edited_full_photo_image
          out[:images][:edited_full_photo] = card_design.edited_full_photo_image.public_url
        end

        render json: out
      end

      format.html do
        expires_in 1.day, public: true if Rails.env == "production"
        redirect_to "/card_printings/#{uid}"
      end
    end
  end
end

