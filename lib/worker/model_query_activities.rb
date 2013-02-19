class ModelQueryActivities
  def get_outgoing_request_ids_for_card_order(card_order_id)
    puts "og req ids #{card_order_id}"
    [1123, 1456]
  end

  def get_sent_request_ids_for_card_order(card_order_id)
    puts "send req ids #{card_order_id}"
    [1123, 1456]
  end

  def get_printable_card_printing_ids(card_order_id)
    puts "print ids #{card_order_id}"
    [2123, 2456]
  end

  def mark_order_as_cancelled(card_order_id)
    puts "cancel #{card_order_id}"
  end

  def mark_order_as_complete(card_order_id)
    puts "complete #{card_order_id}"
  end
end
