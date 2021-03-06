require "outgoing_email_task_generator"

class EmailActivities
  def execute_once?
    true
  end

  def send_email_of_order_received(card_order_id)
    card_order = CardOrder.find(card_order_id)

    if card_order.has_unmailable_printing?
      # This email is only relevant if we have work to do for mailing
      unless card_order.is_promo
        OrderConfirmationMailer.received_email(card_order).deliver
      end
    end

    true
  end

  def send_email_of_address_request_completed(address_request_id)
    true
  end

  def send_email_of_address_request_rejected(address_request_id)
    true
  end

  def send_email_of_address_request_expired(address_request_id)
    true
  end
  
  def send_email_of_submitted_order(card_printing_ids)
    if card_printing_ids.size > 0
      card_order = CardPrinting.find(card_printing_ids[0]).card_order

      unless card_order.is_promo
        OrderConfirmationMailer.printing_email(card_order, card_printing_ids).deliver
      end
    end
    true
  end

  def send_email_of_payment_declined(card_order_id)
    card_order = CardOrder.find(card_order_id)
    OrderConfirmationMailer.declined_email(card_order).deliver
    true
  end

  def send_email_of_printings_mailed(card_printing_ids)
    if card_printing_ids.size > 0
      card_order = CardPrinting.find(card_printing_ids[0]).card_order
      unless card_order.is_promo
        OrderConfirmationMailer.mailed_email(card_order, card_printing_ids).deliver
      end
    end
    true
  end

  def send_email_of_card_scan(card_printing_id)
    true
  end

  def send_email_of_all_addresses_expired(card_order_id)
    card_order = CardOrder.find(card_order_id)
    OrderConfirmationMailer.expired_email(card_order).deliver
    true
  end

  def send_email_of_birthday_request_completed(birthday_request_id)
    true
  end

  def send_email_of_birthday_request_expired(birthday_request_id)
    true
  end

  def send_outgoing_email_task(workload_id, workload_index)
    OutgoingEmailTask.where(workload_id: workload_id, workload_index: workload_index).first.try(:send!)
    true
  end

  def generate_outgoing_email_tasks
    # Hack send flash here
    AdminMailer.daily_flash.deliver

    # Hack do migrations here until new version is out
    User.all.each { |u| u.migrate_postcard_subjects! unless u.user_id == 11 }

    tasks = OutgoingEmailTaskGenerator.new.generate_tasks!

    if tasks.size == 0
      return ["","0"]
    else
      return [tasks[0].workload_id, tasks.size.to_s]
    end
  end

  def send_admin_error_email(subject, body)
    AdminMailer.email_errors(subject, body).deliver
    true
  end
end
