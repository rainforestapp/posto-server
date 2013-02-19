class ManualActivities
  attr_accessor :task_token

  def manual?
    true
  end

  def try_manual_parsing_address_for_request(address_request_id)
    puts "try parsing #{address_request_id} #{self.task_token}"
  end

  def manually_verify_order(card_order_id)
    puts "manual verify #{card_order_id} #{self.task_token}"
  end
end
