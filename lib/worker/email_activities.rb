class EmailActivities
  def execute_once?
    true
  end

  def send_email_of_order_received(card_order_id)
    card_order = CardOrder.find(card_order_id)

    if card_order.has_unmailable_printing?
      # This email is only relevant if we have work to do for mailing
      OrderConfirmationMailer.received_email(card_order).deliver
    end

    true
  end

  def send_email_of_address_request_completed(address_request_id)
    true
  end

  def send_email_of_address_request_expired(address_request_id)
    true
  end
  
  def send_email_of_submitted_order(card_printing_ids)
    if card_printing_ids.size > 0
      card_order = CardPrinting.find(card_printing_ids[0]).card_order
      OrderConfirmationMailer.printing_email(card_order, card_printing_ids).deliver
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
      OrderConfirmationMailer.mailed_email(card_order, card_printing_ids).deliver
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
end
