require "set"

class ModelQueryActivities
  def get_outgoing_request_ids_for_card_order(card_order_id)
    CardOrder.transaction_with_retry do
      close_supplied_address_requests_for_order!(card_order_id)
      get_request_ids_for_state_for_order(card_order_id, :outgoing).to_a.sort
    end
  end

  def get_sent_request_ids_for_card_order(card_order_id)
    CardOrder.transaction_with_retry do
      close_supplied_address_requests_for_order!(card_order_id)
      get_request_ids_for_state_for_order(card_order_id, :sent).to_a.sort
    end
  end

  def get_outgoing_birthday_request_ids_from(birthday_request_ids)
    BirthdayRequest.find(birthday_request_ids).select(&:outgoing?).map(&:birthday_request_id)
  end

  def get_sent_birthday_request_ids_from(birthday_request_ids)
    BirthdayRequest.find(birthday_request_ids).select(&:sent?).map(&:birthday_request_id)
  end

  def get_printable_card_printing_ids(card_order_id)
    CardOrder.find(card_order_id).mailable_card_printings.map(&:card_printing_id)
  end

  def mark_order_as_cancelled(card_order_id)
    CardOrder.transaction_with_retry do
      CardOrder.find(card_order_id).mark_as_cancelled!
    end
  end

  def mark_order_as_failed(card_order_id)
    CardOrder.transaction_with_retry do
      CardOrder.find(card_order_id).mark_as_failed!
    end
  end

  def mark_order_as_rejected(card_order_id)
    CardOrder.transaction_with_retry do
      card_order = CardOrder.find(card_order_id)
      card_order.mark_as_cancelled!
    end

    OrderConfirmationMailer.rejected_email(card_order).deliver
  end

  def mark_order_as_finished(card_order_id)
    CardOrder.transaction_with_retry do
      CardOrder.find(card_order_id).mark_as_finished!
    end
  end

  def get_days_until_share_for_card_order(card_order_id)
    CardOrder.find(card_order_id).days_until_share || -1
  end

  def process_pending_delayed_promo_cards
    DelayedPromoCard.where(created_at: ((3.days.ago)..Time.now)).each(&:try_processing!)
    true
  end

  private

  def close_supplied_address_requests_for_order!(card_order_id)
    card_order = CardOrder.find(card_order_id)
    card_order.close_relevant_supplied_address_requests!
  end

  def get_request_ids_for_state_for_order(card_order_id, state)
    card_order = CardOrder.find(card_order_id)
    card_order.relevant_address_requests.select { |r| r.state == state }.map(&:address_request_id)
  end
end
