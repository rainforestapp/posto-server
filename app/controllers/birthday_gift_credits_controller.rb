class BirthdayGiftCreditsController < ApplicationController
  include ForceSsl

  def index
    api_key = ApiKey.where(token: params[:token]).first
    return head :bad_request unless api_key

    app = App.by_name(params[:app_id])
    return head :bad_request unless app

    user = api_key.user
    postcard_subject = user.postcard_subjects.where(postcard_subject_type: :baby).select { |s| s.state == :active }.first

    return head :bad_request unless postcard_subject

    # This is hacky because there may not be a credit promo code yet for this person 
    # via the email that is sent nightly. (though there should be.)
    #
    # To get around this we either redirect to any existing credit promo created in the last 21 days
    # (regardless if that code has been redeemed) or if none exists we create one. 
    credit_promo = user.intended_credit_promos.where(credit_promo_type: :birthday_reminder, created_at: (21.days.ago)..Time.now).last

    credit_promo ||= user.intended_credit_promos.create(credit_promo_type: :birthday_reminder,
                                                        credits: CONFIG.for_app(app).baby_birthday_bonus_credits,
                                                        app_id: app.app_id)

    redirect_to "/apps/#{app.name}/gift_credits/#{credit_promo.uid}.html?postcard_subject_id=#{postcard_subject.postcard_subject_id}"
  end
end
