class PromosController < ApplicationController
  include ForceSsl

  layout "black"

  def show
    @title = "lulcards: send hilarious REAL photos in the mail"
    
    @promo = CreditPromo.where(uid: params[:promo_code]).first
    @number_of_free_cards = @promo.credits / (CONFIG.processing_credits + CONFIG.card_credits)
    @app = App.by_name(params[:app_id])
    @meta_image = view_context.image_path("InviteHandCard.png")
    @meta_creator = @app.name
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
    @meta_image = view_context.image_path("InviteHandCard.png")
    @meta_creator = @app.name
    @app_url = CONFIG.itunes_url

    promo = CreditPromo.where(uid: params[:promo_code]).first
    @total_credits = 0

    user = User.first_or_create_with_facebook_token(facebook_token)

    if user
      if promo && promo.state == :pending

        User.transaction_with_retry do
          if user
            promo.granted_to_user_id = user.user_id
            promo.save!
            promo.state = :granted

            user.add_credits!(promo.credits, app: app, source_type: :promo, source_id: promo.credit_promo_id)
          end
        end
      end

      @total_credits = user.credits_for_app(app)
    end

    render
  end
end
