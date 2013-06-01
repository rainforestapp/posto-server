require "date"

# run this at 13:00 GMT, 6AM PST, 9AM EST

class OutgoingEmailTaskGenerator
  def generate_tasks!(params = {})
    drip_map = generate_drip_map(params)
    reminder_map = generate_reminder_map(params)

    workload_id = SecureRandom.hex

    [].tap do |outgoing_email_tasks|
      OutgoingEmailTask.transaction_with_retry do
        [drip_map, reminder_map].each do |task_map|
          task_map.each do |recipient_user_id, info|
            app_id = info[:app_id]
            email_type = info[:email_type]
            email_args = info[:email_args]
            
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
                                                                 app_id: app_id,
                                                                 recipient_user_id: recipient_user_id)
            end
          end
        end
      end
    end
  end

  private

  def generate_drip_map(params = {})
    today = params[:today] || Time.new

    {}.tap do |drip_map|
      # send drip email to users who have email addresses, no orders, and credits for an app 
      { drip_1_week: 1.weeks, 
        drip_3_week: 3.weeks, 
        drip_8_week: 7.weeks,
        drip_12_week: 11.weeks,
      }.each do |email_type, timespan|
        users = User.where(created_at: (today - timespan - 1.day) .. (today - timespan))
        users = users.select { |u| u.user_profile.try(:email) }
        users = users.select { |u| u.card_orders.size == 0 }

        [App.babygrams].each do |drippable_app|
          users.each do |u|
            if u.credits_for_app(drippable_app) > 0
              unless u.is_opted_out_of_email_class?(:drip)
                drip_map[u.user_id] = { app_id: drippable_app.app_id, 
                                        email_type: email_type,
                                        email_args: { user_id: u.user_id, app_id: drippable_app.app_id } }
              end
            end
          end
        end
      end

      # Email welcome email 9 days after order is mailed
      orders = CardOrderState.where(created_at: (today - 10.days)..(today - 9.days), state: :finished).map(&:card_order)

      orders.each do |order|
        if order.order_sender_user.first_order == order
          drip_map[order.order_sender_user.user_id] = {
            app_id: order.app_id,
            email_type: :drip_welcome,
            email_args: { user_id: order.order_sender_user_id, app_id: order.app_id }
          }
        end
      end
    end
  end

  def generate_reminder_map(params = {})
    today = params[:today].try(:to_date) || Time.new.to_date

    # map user_id 
    {}.tap do |reminder_map|
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
            unless author.is_opted_out_of_email_class?(:reminders)
              unless author.last_card_order && author.last_card_order.created_at > Time.now - config.min_baby_birthday_reminder_delay_days.days
                reminder_map[card_design.author_user_id] = { 
                  app_id: card_design.app_id, 
                  email_type: :birthday_reminder,
                  email_args: { card_design_id: card_design.card_design_id } 
                }
              end
            end
          end
        end
      end
    end
  end
end
