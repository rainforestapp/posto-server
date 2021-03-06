class PromosController < ApplicationController
  include ForceSsl

  layout "black"

  def show
    @app = App.by_name(params[:app_id])
    @config = CONFIG.for_app(@app)

    @title = @config.page_title
    @tagline = @config.page_tagline
    
    @number_of_free_cards = 0
    @promo = CreditPromo.where(uid: params[:promo_code]).first

    if @promo
      @number_of_free_cards = @promo.credits / (@config.processing_credits + @config.card_credits)
    end

    @meta_image = view_context.image_path("#{@app.name}/InviteHandCard.png")
    @meta_creator = @app.name
    @disable_itunes_link = true
  end

  def create
    facebook_token = params[:facebook_token]
    promo_code = params[:promo_code]
    app = params[:app_id]

    return head :bad_request unless facebook_token
    return head :bad_request unless app

    app = App.by_name(app)
    return head :bad_request unless app

    @app = app
    @meta_image = view_context.image_path("#{@app.name}/InviteHandCard.png")
    @meta_creator = @app.name
    @app_url = @config.itunes_url

    promo = CreditPromo.where(uid: params[:promo_code]).first
    @total_credits = 0

    user = User.first_or_create_with_facebook_token(facebook_token)

    if user
      if promo
        User.transaction_with_retry do
          promo.grant_to!(user)
        end
      end

      @total_credits = user.credits_for_app(app)
    end

    render
  end
end
