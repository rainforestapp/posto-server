class NotificationActivities
  def send_notification_of_address_request_completed(address_request_id)
    puts "send address req completed notification"
  end

  def send_notification_of_address_request_expired(address_request_id)
    puts "send address req expired notification"
  end
  
  def send_notification_of_submitted_order(card_printing_ids)
    puts "send order sent #{card_printing_ids.inspect} notification"
  end

  def send_notification_of_payment_declined(card_order_id)
    puts "send payment declined #{card_order_id} notification"
  end

  def send_notification_of_printings_mailed(card_printing_ids)
    puts "send mailed #{card_printing_ids.inspect} notification"
  end

  def send_notification_of_card_scan(card_printing_id)
    puts "send card scan #{card_printing_id} notification"
  end

  def send_notification_of_all_addresses_expired(card_order_id)
    puts "send all expired #{card_order_id} notification"
  end
end
