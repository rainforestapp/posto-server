require "date_helper"

class ReminderMailer < ActionMailer::Base
  default from: "babygrams <support@babygrams.com>"
  layout "email_action"

  def birthday_reminder(params)
    @postcard_subject = PostcardSubject.find(params[:postcard_subject_id])
    return unless @postcard_subject

    @card_design = @postcard_subject.user.authored_card_designs.select do |d|
      d.postcard_subject && d.postcard_subject[:name] == @postcard_subject.name
    end.last

    @task = params[:outgoing_email_task]

    @app = @postcard_subject.app
    @config = CONFIG.for_app(@app)
    @author = @postcard_subject.user

    return if @author.is_opted_out_of_email_class?(:reminders)

    last_orders = @author.card_orders.select { |o| o.app_id == @app.app_id }.sort_by(&:created_at)

    if last_orders.size > 3
      last_orders = last_orders[-3..-1]
    end

    return if last_orders.size == 0

    last_recipients = last_orders.map(&:card_printings).flatten.map(&:recipient_user).uniq.select { |u| u != @author }
    last_names = last_recipients.map(&:user_profile).compact.map { |profile| profile.first_name || profile.name }.compact

    if last_names.size > 0
      @last_names = last_names

      if last_recipients.size == 1 && last_recipients[0].user_profile
        @last_recipient_profile = last_recipients[0].user_profile
      end
    end

    @gender_color = "#5FB5E5"

    @subject_first_name = @postcard_subject.name.split(/\s+/)[0]

    if @postcard_subject.gender == "girl"
      @gender_color = "#EB6C9A"
    end

    @age = DateHelper.printable_age(Time.now, @postcard_subject.birthday - 2.days, true)
    @age_singular = DateHelper.printable_age(Time.now, @postcard_subject.birthday - 2.days, false)

    recipient_address = "gfodor@gmail.com"

    unless Rails.env == "development"
      @author.refresh_user_profile!
      recipient_address = @author.user_profile.email
    end

    @target_url = "http://#{@app.domain}/email_clicks/#{@task.try(:uid)}"
    @unsubscribe_url = "http://#{@app.domain}/unsubscribes/#{@task.try(:uid)}"
    @subject = "#{@subject_first_name} is #{@age} old! Happy birthday from #{@app.name}."

    if (@config.baby_birthday_bonus_credits || 0) > 0
      @subject = "#{@subject_first_name} is #{@age} old! Here's a free gift from #{@app.name}."

      @credit_promo = CreditPromo.create!(app_id: @app.app_id, 
                                         credits: @config.baby_birthday_bonus_credits, 
                                         credit_promo_type: :birthday_reminder,
                                         intended_recipient_user_id: @author.user_id)

      @target_url = "http://#{@app.domain}/gift_credits/#{@credit_promo.uid}?postcard_subject_id=#{@postcard_subject.postcard_subject_id}"
    end

    if recipient_address
      mail(to: recipient_address, from: @config.from_reminder_email, subject: @subject)
    else
      return nil
    end
  end
end
