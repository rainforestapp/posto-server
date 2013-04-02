class SignupsController < ApplicationController
  layout "black"

  def show
    @title = "lulcards: send hilarious REAL postcards"
    @number_of_free_cards = CONFIG.signup_credits / (CONFIG.processing_credits + CONFIG.card_credits)
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
        # TODO reward referral
        user.add_credits!(CONFIG.signup_credits,
                          app: app,
                          source_type: :signup,
                          source_id: user.user_id)
      end
    end

    redirect_to CONFIG.itunes_url
  end
end
