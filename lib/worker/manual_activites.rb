class ManualActivities
  attr_accessor :task_token

  def manual?
    true
  end

  def tryManualParsingAddressForRequest(address_request_id)
    puts "try parsing #{address_request_id} #{self.task_token}"
  end

  def manuallyVerifyOrder(card_order_id)
    puts "manual verify #{card_order_id} #{self.task_token}"
  end
end
