class IndexController < ApplicationController
  def show
    #expires_in 1.hour, public: true if Rails.env == "production"

    #render
    redirect_to "http://www.lulcards.com"
  end
end
