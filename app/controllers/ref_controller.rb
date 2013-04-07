class RefController < ApplicationController
  def show
    # TODO based upon domain

    promo = CreditPromo.where(uid: params[:id]).first

    if promo
      redirect_to "https://api.lulcards.com/apps/lulcards/promo?promo_code=#{params[:id]}"
    else
      redirect_to "https://api.lulcards.com/apps/lulcards/signup?referral_code=#{params[:id]}"
    end
  end
end
