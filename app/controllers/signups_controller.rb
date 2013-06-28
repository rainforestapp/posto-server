class SignupsController < ApplicationController
  include ForceSsl

  layout "black"

  def show
    @app = App.by_name(params[:app_id])
    @theme_color = "white" if @app == App.babygrams

    @config = CONFIG.for_app(@app)

    @title = @config.page_title
    @tagline = @config.page_tagline

    @number_of_free_cards = @config.signup_credits / (@config.processing_credits + @config.card_credits)
    
    @meta_image = view_context.image_path("#{@app.name}/InviteHandCard.png")
    @meta_creator = @app.name
    @disable_itunes_link = true
    @card_image = "#{@app.name}/InviteHandCard.png"

    if params[:referral_code]
      referring_user = User.where(uid: params[:referral_code]).first

      if referring_user
        @card_order = nil

        referring_user.card_orders.each do |card_order|
          next unless card_order.app == @app

          if card_order.card_design.postcard_subject &&
             card_order.card_design.postcard_subject[:subject_type] == "baby" &&
             card_order.card_design.card_preview_composition
            @card_order = card_order
          end
        end

        if @card_order
          subject_first = @card_order.card_design.postcard_subject[:name].split(/\s+/)[0]
          @tagline = "#{@card_order.order_sender_user.user_profile.first_name} has been mailing real printed pictures of #{subject_first} with #{@app.name}!"
          @card_image = @card_order.card_design.card_preview_composition.treated_card_preview_image.public_url
          @lead_extra = "Connect with Facebook and install the app, and you'll earn an extra bonus card for both you and #{@card_order.order_sender_user.user_profile.first_name}!"
        end
      end
    end
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

    redirect_to @config.itunes_url
  end
end
