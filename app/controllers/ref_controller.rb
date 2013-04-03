class RefController < ApplicationController
  def show
    # TODO based upon domain
    redirect_to "https://api.lulcards.com/apps/lulcards/signup?referral_code=#{params[:id]}"
  end
end
