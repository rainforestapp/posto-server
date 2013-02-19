class AmazingMailActivities
  def submit_images_to_amazing_mail(card_order_id)
    puts "submit to amazing mail #{card_order_id}"
  end

  def check_if_amazing_mail_has_images(card_order_id)
    puts "check az images #{card_order_id}"
    # "ready", "not_ready"
    "ready"
  end

  def submit_printing_requests_to_amazing_mail(card_printing_ids)
    puts "submit az requests #{card_printing_ids}"
    ["print_req_1", "print_req_2"]
  end

  def check_if_printing_request_has_been_confirmed(printing_request_id)
    puts "check az confirmed #{printing_request_id}"
    # "confirmed", "not_confirmed", or throw if bad state
    "confirmed"
  end
end
