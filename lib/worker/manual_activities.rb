class ManualActivities
  attr_accessor :task_token

  def manual?
    true
  end

  def queue_prefix
    Rails.env == "development" ? "posto-dev" : "posto-prod"
  end

  def try_manual_parsing_address_for_request(address_request_id)
    queue_name = "#{queue_prefix}-manual-address-parse"
    payload = { address_request_id: address_request_id, task_token: self.task_token }
    AWS::SQS.new.queues.named(queue_name).send_message(payload.to_json)
    true
  end

  def manually_verify_order(card_order_id)
    queue_name = "#{queue_prefix}-manual-verify-order"
    payload = { card_order_id: card_order_id, task_token: self.task_token }
    AWS::SQS.new.queues.named(queue_name).send_message(payload.to_json)
    true
  end
end
