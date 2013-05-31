require "date_helper"

class DripMailer < ActionMailer::Base
  default from: "babygrams <support@babygrams.com>"
  layout "email_action"

  def drip_1_week(params)
    @gender_color = "#5FB5E5"
    send_drip_email("A surprise in the mail for grandparents", params)
  end

  def drip_3_week(params)
    @gender_color = "#EB6C9A"
    send_drip_email("You still have some free babygrams to send", params)
  end

  def drip_8_week(params)
    @gender_color = "#5FB5E5"
    send_drip_email("Grandparents won't stop talking about babygrams", params)
  end

  def drip_12_week(params)
    @gender_color = "#EB6C9A"
    send_drip_email("Everyone smiles when they get a babygram", params)
  end

  private

  def send_drip_email(subject, params)
    @user = User.find(params[:user_id])
    @app = App.find(params[:app_id])
    @task = nil
    @task = params[:outgoing_email_task]
    @config = CONFIG.for_app(@app)
    return if @user.is_opted_out_of_email_class?(:drip)

    @number_of_free_cards = (@user.credits_for_app(@app) / @config.card_credits).floor.to_i
    return if @number_of_free_cards <= 0

    @target_url = "http://#{@app.domain}/email_clicks/#{@task.try(:uid)}"
    @unsubscribe_url = "http://#{@app.domain}/unsubscribes/#{@task.try(:uid)}"

    recipient_address = "gfodor@gmail.com"

    #unless Rails.env == "development"
    #  recipient_address = @user.user_profile.email
    #end

    mail(to: recipient_address,
         from: @config.from_reminder_email,
         subject: subject)
  end
end
