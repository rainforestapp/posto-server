class QrController < ApplicationController
  include ApiSecureEndpoint 

  allow_unauthenticated_access!

  def show
    uid = params[:id][1..-1]
    type = params[:id][0]

    unless params[:id] && params[:app] && params[:device_uuid]
      head :bad_request
      return
    end

    app = App.by_name(params[:app])
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
    card_design = card_order.card_design
    preview_composition = card_design.card_preview_composition
    sender = card_order.order_sender_user

    if device_uuid.blank?
      head :bad_request
      return
    end

    user_id = @current_user.try(:user_id)

    is_first_scan = card_printing.card_scan.nil?

    card_scan = card_printing.card_scans.create!(
      device_uuid: device_uuid,
      scanned_by_user_id: user_id,
      scanned_at: Time.zone.now,
      app_id: app.app_id,
      scan_position: position,
    )

    card_scan.send_notification! if is_first_scan

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

