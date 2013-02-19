class AmazingMailActivities
  def submit_images_to_amazing_mail(card_order_id)
    puts "submit to amazing mail #{card_order_id}"
    ["4444","5555"]
  end

  def check_if_amazing_mail_has_images(queued_image_ids)
    puts "check az images #{queued_image_ids.inspect}"
    # "ready", "not_ready"
    "ready"
  end

  def submit_printing_request_to_amazing_mail(card_printing_ids)
    puts "submit az request #{card_printing_ids.inspect}"
    "5884949"
  end

  def check_if_printing_request_has_been_confirmed(import_id)
    puts "check az confirmed #{import_id}"
    # "confirmed", "not_confirmed", or throw if bad state
    "confirmed"
  end
end
