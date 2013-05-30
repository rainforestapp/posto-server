require "date_helper"

class ReminderMailer < ActionMailer::Base
  default from: "babygrams <support@babygrams.com>"
  layout "email_action"

  def birthday_reminder(card_design, outgoing_email_task)
    @card_design = card_design
    @task = outgoing_email_task

    @app = card_design.app
    @config = CONFIG.for_app(@app)
    @author = card_design.author_user

    last_orders = @author.card_orders.select { |o| o.app == @app }.sort_by(&:created_at)[-3..-1]
    last_recipients = last_orders.map(&:card_printings).flatten.map(&:recipient_user).uniq.select { |u| u != @author }
    last_names = last_recipients.map(&:user_profile).compact.map(&:name).compact

    if last_names.size > 0
      @last_names = last_names

      if last_recipients.size == 1 && last_recipients[0].user_profile
        @last_recipient_profile = last_recipients[0].user_profile
      end
    end

    @gender_color = "#5FB5E5"

    if card_design.postcard_subject
      if card_design.postcard_subject[:name]
        @subject_first_name = card_design.postcard_subject[:name].split(/\s+/)[0]
      else
        @subject_first_name = "your baby"
      end

      if card_design.postcard_subject[:gender] == "girl"
        @gender_color = "#EB6C9A"
      end

      birthday = Chronic.parse(card_design.postcard_subject[:birthday])
      @age = DateHelper.printable_age(Time.now, birthday - 2.days, false)
    end

    recipient_address = "gfodor@gmail.com"

    #unless Rails.env == "development"
    #  recipient_address = @author.user_profile.email
    #end

    @target_url = "http://#{@app.domain}/email_clicks/#{@task.try(:uid)}"
    @unsubscribe_url = "http://#{@app.domain}/unsubscribes/#{@task.try(:uid)}"

    mail(to: recipient_address,
         from: @config.from_reminder_email,
         subject: "Happy #{@age} birthday to #{@subject_first_name} from #{@app.name}!")
  end
end
