module Admin
  class PromoCodesController < AdminController
    def new
    end

    def create
      app = App.by_name(params[:app])
      credits = params[:credits].to_i
      credit_promo = CreditPromo.create!(app_id: app.app_id, credits: credits)
      credit_promo.state = :pending
      @credit_promo = credit_promo
    end
  end
end
