class PaymentActivities
  def charge_order_for_printing_ids(card_order_id, card_printing_ids)
    puts "charge #{card_order_id} #{card_printing_ids.inspect}"
    # return "declined"
    "charged"
  end
end
