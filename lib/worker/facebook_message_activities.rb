class FacebookMessageActivities
  def send_message_for_address_request(address_request_id)
    puts "fb send #{address_request_id}"
  end

  def check_for_address_request_progress(address_request_id)
    puts "check fb progress #{address_request_id}"
    # return "has_message", "has_address", "no_progress"
    "has_message"
  end
end
