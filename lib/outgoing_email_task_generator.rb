require "date"

# run this at 13:00 GMT, 6AM PST, 9AM EST

class OutgoingEmailTaskGenerator
  def generate_birthday_reminder_tasks!(params = {})
    today = params[:today] || Time.new.to_date

    # map user_id 
    reminder_map = {}

    # Super lame algorithm
    CardDesign.all(order: "card_design_id asc").each do |card_design|
      next unless card_design.postcard_subject
      postcard_subject = card_design.postcard_subject
      birthday = postcard_subject[:birthday]
      next unless birthday
      birthday = Chronic.parse(birthday).to_time
      next unless card_design.app == App.babygrams

      author = card_design.author_user
      config = CONFIG.for_app(card_design.app)

      config.baby_birthday_reminders.each do |reminder|
        reminder_date = birthday.advance(months: reminder[:months], weeks: reminder[:weeks]).to_date

        if reminder_date == today
          unless author.last_card_order && author.last_card_order.created_at > Time.now - config.min_baby_birthday_reminder_delay_days.days
            reminder_map[card_design.author_user_id] = { reminder: reminder, card_design_id: card_design.card_design_id }
          end
        end
      end
    end
    
    workload_id = SecureRandom.hex

    [].tap do |outgoing_email_tasks|
      OutgoingEmailTask.transaction_with_retry do
        reminder_map.each do |recipient_user_id, info|
          reminder = info[:reminder]
          card_design_id = info[:card_design_id]

          email_type = :birthday_reminder
          email_args = { card_design_id: card_design_id,
                         months: reminder[:months],
                         weeks: reminder[:weeks] }
          
          already_sent = false

          OutgoingEmailTask.where(recipient_user_id: recipient_user_id).each do |task|
            already_sent ||= task.has_been_sent? && task.email_type == email_type && task.email_args == email_args 
          end

          unless already_sent
            outgoing_email_tasks <<  OutgoingEmailTask.create!(workload_id: workload_id,
                                                               workload_index: outgoing_email_tasks.size,
                                                               email_type: email_type,
                                                               email_variant: "default",
                                                               email_args: email_args,
                                                               recipient_user_id: recipient_user_id)
          end
        end
      end
    end
  end
end
