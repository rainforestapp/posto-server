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

    expires_in 1.day, public: true if Rails.env == "production"

    # TODO do something better
    redirect_to "/card_printings/#{card_printing.uid}"
  end
end
