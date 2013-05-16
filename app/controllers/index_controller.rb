class IndexController < ApplicationController
  def show
    #expires_in 1.hour, public: true if Rails.env == "production"

    if request.host == "sendmebabygrams.com"
      redirect_to "https://secure.babygra.ms/apps/babygrams/gift_credits"
    elsif request.host == "babygramsapp.com"
      redirect_to "http://babygra.ms"
    else
      redirect_to "http://www.lulcards.com"
    end
  end
end
