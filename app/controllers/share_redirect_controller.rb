class ShareRedirectController < ApplicationController
  def show
    uid = params[:id][1..-1]

    unless params[:id]
      head :bad_request
      return
    end

    card_printing = CardPrinting.where(uid: uid).first

    unless card_printing
      head :bad_request
      return
    end

    # TODO do something better
    redirect_to card_printing.card_printing_composition.jpg_card_front_image.public_url
  end
end
