class RefController < ApplicationController
  def show
    # TODO based upon domain

    promo = CreditPromo.where(uid: params[:id]).first

    if promo
      redirect_to "https://api.lulcards.com/apps/#{promo.app.name}/promo?promo_code=#{params[:id]}"
    else
      app = params[:app] || "lulcards"
      redirect_to "https://api.lulcards.com/apps/#{app}/signup?referral_code=#{params[:id]}"
    end
  end
end
