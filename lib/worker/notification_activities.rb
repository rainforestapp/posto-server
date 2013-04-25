class NotificationActivities
  def execute_once?
    true
  end

  def send_notification_of_order_received(card_order_id)
    true
  end

  def send_notification_of_address_request_completed(address_request_id)
    address_request = AddressRequest.find(address_request_id)
    sender = address_request.request_sender_user
    recipient = address_request.request_recipient_user

    if recipient.user_profile && recipient.recipient_address
      recipient_name = recipient.user_profile.first_name
      possessive_pronoun = recipient.user_profile.possessive_pronoun
      city = recipient.recipient_address.city
      state = recipient.recipient_address.state
      message = "#{recipient_name} provided #{possessive_pronoun} address in #{city}, #{state}. We'll mail #{possessive_pronoun} card to this address."
      address_request.send_sender_notification(message)
    end
    true
  end

  def send_notification_of_birthday_request_completed(birthday_request_id)
    birthday_request = BirthdayRequest.find(birthday_request_id)
    sender = birthday_request.request_sender_user
    recipient = birthday_request.request_recipient_user

    if recipient.user_profile && recipient.has_birthday?
      recipient_name = recipient.user_profile.first_name
      possessive_pronoun = recipient.user_profile.possessive_pronoun
      birthday = recipient.printable_birthday
      message = "#{recipient_name}'s birthday is on #{birthday}. Slide to set a reminder."
      birthday_request.send_sender_notification(message)
    end

    true
  end

  def send_notification_of_address_request_rejected(address_request_id)
    true
  end

  def send_notification_of_address_request_expired(address_request_id)
    true
  end

  def send_notification_of_birthday_request_expired(address_request_id)
    true
  end
  
  def send_notification_of_submitted_order(card_printing_ids)
    if card_printing_ids.size > 0
      card_order = CardPrinting.find(card_printing_ids[0]).card_order
      message = "Your order has been sent for printing."

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
    true
  end

  def send_notification_of_payment_declined(card_order_id)
    card_order = CardPrinting.find(card_order_id).card_order
    message = "We're really sorry, but your order had to be cancelled because your payment method was declined."
    card_order.send_order_notification(message)
    true
  end

  def send_notification_of_printings_mailed(card_printing_ids)
    if card_printing_ids.size > 0
      card_order = CardPrinting.find(card_printing_ids[0]).card_order
      message = "Your order has been mailed! It should arrive in 5-7 business days."
      card_order.send_order_notification(message)
    end
    true
  end

  def send_notification_of_card_scan(card_printing_id)
    true
  end

  def send_notification_of_all_addresses_expired(card_order_id)
    card_order = CardPrinting.find(card_order_id).card_order
    message = "We're really sorry, but your order had to be cancelled because your recipients never provided their addresses."
    card_order.send_order_notification(message)
    true
  end
end
