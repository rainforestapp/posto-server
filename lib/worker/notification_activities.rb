class NotificationActivities
  def execute_once?
    true
  end

  def send_notification_of_address_request_completed(address_request_id)
  end

  def send_notification_of_address_request_expired(address_request_id)
  end
  
  def send_notification_of_submitted_order(card_printing_ids)
    if card_printing_ids.size > 0
      card_order = CardPrinting.find(card_printing_ids[0]).card_order
      message = "Your order ##{card_order.order_number} has been sent for printing."

      missing_address_count = card_order.card_printings.size - card_printing_ids.size

      if missing_address_count > 0 
        if card_printing_ids.size == 1
          message += " #{missing_address_count} of your recipients never replied with their address, so only 1 card was sent."
        else
          message += " #{missing_address_count} of your recipients never replied with their address, so only #{card_printing_ids.size} cards were sent."
        end
      end

      card_order.send_order_notification(message)
    end
  end

  def send_notification_of_payment_declined(card_order_id)
    card_order = CardPrinting.find(card_order_id).card_order
    message = "We're really sorry, but your order ##{card_order.order_number} had to be cancelled because your payment method was declined."
    card_order.send_order_notification(message)
  end

  def send_notification_of_printings_mailed(card_printing_ids)
    if card_printing_ids.size > 0
      card_order = CardPrinting.find(card_printing_ids[0]).card_order
      message = "Your order ##{card_order.order_number} has been mailed and should arrive in 5-7 business days."
      card_order.send_order_notification(message)
    end
  end

  def send_notification_of_card_scan(card_printing_id)
  end

  def send_notification_of_all_addresses_expired(card_order_id)
    card_order = CardPrinting.find(card_order_id).card_order
    message = "We're really sorry, but your order ##{card_order.order_number} had to be cancelled because your recipients never provided their addresses."
    card_order.send_order_notification(message)
  end
end
