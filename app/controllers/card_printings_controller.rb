class CardPrintingsController < ApplicationController
  layout "black"

  def show
    uid = params[:id]

    @card_printing = CardPrinting.where(uid: uid).first
    @card_order = @card_printing.card_order
    @sender = @card_order.order_sender_user
    @sender_name = @sender.user_profile.name
    @card_design = @card_order.card_design
    @app = @card_order.app
    @image_url = @card_printing.card_printing_composition.jpg_card_front_image.public_url
    @profile_image_url = @sender.profile_image_url
    @sent_on = @card_order.created_at.strftime("%-m/%-d/%y")
    @meta_image = @image_url
    @meta_creator = @sender_name
    @meta_url = "http://#{@app.domain}/card_printings/#{@card_printing.uid}"

    @full_text = (@card_design.top_caption + " " + @card_design.bottom_caption).truncate(30)
    @full_text = @full_text.gsub(/  /, " ").gsub(/^ */, "").gsub(/ *$/, "")

    @title = "#{@full_text} card by #{@sender_name} - #{@app.name}"

    unless @card_printing
      head :bad_request
    else
      expires_in 1.hour, public: true if Rails.env == "production"
      render
    end
  end
end
