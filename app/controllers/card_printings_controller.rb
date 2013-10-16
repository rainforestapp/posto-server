class CardPrintingsController < ApplicationController
  layout "black"

  def show
    uid = params[:id]
    @card_printing = CardPrinting.where(uid: uid).first
    @card_order = @card_printing.card_order
    @sender = @card_order.order_sender_user
    @sender_name = @sender.user_profile.name
    @sender_possessive = @sender.user_profile.possessive_pronoun
    @sender_first_name = @sender.user_profile.first_name
    @card_design = @card_order.card_design
    @message = @card_design.note if @card_design.note && @card_design.note.size > 0
    @app = @card_order.app
    @config = CONFIG.for_app(@app)
    @image_url = @card_printing.card_printing_composition.jpg_card_front_image.public_url
    @profile_image_url = @sender.profile_image_url
    @sent_on = @card_order.created_at.strftime("%-m/%-d/%y")
    @meta_image = @image_url
    @meta_creator = @app.name
    @meta_url = "http://#{@app.domain}/card_printings/#{@card_printing.uid}"
    @og_type = @config.open_graph_type
    @is_mobile = self.mobile_agent?
    @location = ""

    @theme_color = "white" if @app == App.babygrams
    @sent_by_caption = "Sent by #{@sender.user_profile.name} with #{@app.name}"

    @full_text = (@card_design.top_caption + " " + @card_design.bottom_caption).truncate(30)
    @full_text = @full_text.gsub(/  /, " ").gsub(/^ */, "").gsub(/ *$/, "")

    if @app == App.lulcards
      @title = "#{@full_text} card by #{@sender_name} - made with #{@app.name}".strip
      @og_title = "#{@full_text} card".strip
    elsif @app == App.babygrams
      baby_name = ""

      postcard_subject = @card_design.postcard_subject

      if postcard_subject && postcard_subject[:name]
        baby_name = " of #{postcard_subject[:name]}"
        short_baby_name = " of #{postcard_subject[:name].split(/\s+/)[0]}"
      end

      @description = "#{@sender_first_name} designed, printed & mailed this photo#{baby_name} to someone special from #{@sender_possessive} iPhone with #{@app.name}."

      @title = "#{@app.name.capitalize} - Photo postcard#{baby_name}".strip
      @og_title = "#{@app.name.capitalize} photo postcard#{baby_name}"

      @sent_by_caption = "#{@sender.user_profile.first_name} mailed this printed photo#{short_baby_name} from #{@sender.user_profile.possessive_pronoun} iPhone with #{@app.name}."
    else
      @title = @config.page_title
    end

    @tagline = @config.page_tagline

    unless @card_printing
      head :bad_request
    else
      expires_in 1.hour, public: true if Rails.env == "production"
      render
    end
  end
end
