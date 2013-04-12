class SignupsController < ApplicationController
  include ForceSsl

  layout "black"

  def show
    @title = "lulcards: send hilarious REAL photos in the mail"
    @number_of_free_cards = @config.signup_credits / (@config.processing_credits + @config.card_credits)
    
    @app = App.by_name(params[:app_id])
    @meta_image = view_context.image_path("InviteHandCard.png")
    @meta_creator = @app.name
    @disable_itunes_link = true
  end

  def create
    facebook_token = params[:facebook_token]
    referral_code = params[:referral_code]
    app = params[:app_id]

    return head :bad_request unless facebook_token
    return head :bad_request unless app

    app = App.by_name(app)
    return head :bad_request unless app

    user = User.first_or_create_with_facebook_token(facebook_token)

    if user
      if user.has_empty_credit_journal_for_app?(app)
        if params[:referral_code]
          referring_user = User.where(uid: params[:referral_code]).first

          if referring_user
            existing_referral = UserReferral.where(referred_user_id: user.user_id,
                                                   app_id: app.app_id).first

            unless existing_referral
              UserReferral.create!(referred_user_id: user.user_id,
                                   referring_user_id: referring_user.user_id,
                                   app_id: app.app_id)
            end
          end
        end
      end
    end

    redirect_to CONFIG.itunes_url
  end
end
