require "date_helper"

class DripMailer < ActionMailer::Base
  default from: "babygrams <support@babygrams.com>"
  layout "email_action"

  def drip_welcome(params)
    @user = User.find(params[:user_id])
    @app = App.find(params[:app_id])
    return if @user.is_opted_out_of_email_class?(:drip)
    return unless @app == App.babygrams

    @config = CONFIG.for_app(@app)

    recipient_address = "gfodor@gmail.com"

    unless Rails.env == "development"
      recipient_address = @user.user_profile.email
    end

    orders = @user.card_orders.where(app_id: @app.app_id)
    subject = "How did your #{@app.name} order go?"
    card_name = @app == App.babygrams ? "babygram" : "lulcard"

    if orders.size > 0
      printings = orders.map(&:card_printings).flatten

      printings = printings.select do |p| 
        p.recipient_user != @user && p.recipient_user.user_profile.try(:name) != @user.user_profile.name 
      end
      
      profiles = printings.map(&:recipient_user).uniq.map(&:user_profile).compact

      if profiles.size == 1
        if profiles[0].first_name
          subject = "How did #{profiles[0].first_name} enjoy #{profiles[0].possessive_pronoun} #{card_name}?"
        end
      elsif profiles.size > 1
        subject = "How did #{profiles.map(&:first_name).compact.to_sentence} enjoy their #{card_name.pluralize}?"
      end
    end

    promo = CreditPromo.create!(app_id: @app.app_id, credits: @config.card_credits)

    @promo_url = "https://secure.babygra.ms/ref/#{promo.uid}"

    mail(to: recipient_address,
         from: "Greg Fodor <gfodor@babygra.ms>",
         subject: subject)
  end

  def drip_1_day(params)
    @gender_color = "#5FB5E5"
    send_drip_email("You can still send NUMBER_OF_FREE_CARDS free ENTITY!", params)
  end

  def drip_1_week(params)
    @gender_color = "#5FB5E5"
    send_drip_email("You still have NUMBER_OF_FREE_CARDS free ENTITY left to send!", params)
  end

  def drip_3_week(params)
    @gender_color = "#EB6C9A"
    send_drip_email("Surprise grandparents with NUMBER_OF_FREE_CARDS free ENTITY", params)
  end

  def drip_8_week(params)
    @gender_color = "#5FB5E5"
    send_drip_email("You can still send NUMBER_OF_FREE_CARDS ENTITY for free!", params)
  end

  def drip_12_week(params)
    @gender_color = "#EB6C9A"
    send_drip_email("You still have NUMBER_OF_FREE_CARDS free ENTITY!", params)
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

    subject = subject.gsub(/NUMBER_OF_FREE_CARDS/, @number_of_free_cards == 1 ? "a" : @number_of_free_cards.to_s)
    subject = subject.gsub(/ENTITY/, @config.entity.pluralize(@number_of_free_cards))

    @target_url = "http://#{@app.domain}/email_clicks/#{@task.try(:uid)}"
    @unsubscribe_url = "http://#{@app.domain}/unsubscribes/#{@task.try(:uid)}"

    recipient_address = "gfodor@gmail.com"

    unless Rails.env == "development"
      recipient_address = @user.user_profile.email
    end

    if recipient_address
      mail(to: recipient_address,
          from: @config.from_reminder_email,
          subject: subject)
    else
      return nil
    end
  end
end
