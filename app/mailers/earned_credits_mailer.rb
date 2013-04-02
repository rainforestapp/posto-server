class EarnedCreditsMailer < ActionMailer::Base
  default from: "lulcards rewards <rewards@lulcards.com>"
  layout "email"

  def referral(referring_user, referred_user, app)
    with_recipient_address_for_user(referring_user) do |recipient_address|
      @earned_credits = CONFIG.referral_credits
      @referring_user = referring_user
      @referred_user = referred_user
      @app = app

      mail(to: recipient_address,
           subject: "You earned #{@earned_credits} #{app.name} credits")
    end
  end

  def with_recipient_address_for_user(user)
    user_profile = user.try(:user_profile) 
    recipient_email_address = user_profile.try(:email)
    recipient_name = user_profile.try(:name)

    if Rails.env == "development"
      recipient_email_address = "gfodor@gmail.com"
    end

    if recipient_email_address && recipient_name
      yield "#{recipient_name} <#{recipient_email_address}>"
    elsif recipient_email_address
      yield recipient_email_address
    end
  end
end
