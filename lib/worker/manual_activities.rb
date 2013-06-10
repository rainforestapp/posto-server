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

    if ENV["MANUAL_NOTIFY_EMAIL_ADDRESS"]
      if rand() <= CONFIG.address_request_admin_notify
        AWS::SimpleEmailService.new.send_email(
          subject: "[POSTO MANUAL] Address Request ##{address_request_id}",
          from: "orders@lulcards.com",
          to: ENV["MANUAL_NOTIFY_EMAIL_ADDRESS"],
          body_text: ""
        ) rescue nil
      end
    end

    true
  end

  def manually_verify_order(card_order_id)
    unless rand() <= CONFIG.card_order_approve_amount || CardOrder.find(card_order_id).order_sender_user_id == 11
      AWS::SimpleWorkflow::Client.new().respond_activity_task_completed(:task_token => self.task_token, 
                                                                        :result => "verified".to_json)
      return true
    end

    queue_name = "#{queue_prefix}-manual-verify-order"
    payload = { card_order_id: card_order_id, task_token: self.task_token }
    AWS::SQS.new.queues.named(queue_name).send_message(payload.to_json)

    if ENV["MANUAL_NOTIFY_EMAIL_ADDRESS"]
      if rand() <= CONFIG.card_order_admin_notify
        AWS::SimpleEmailService.new.send_email(
          subject: "[POSTO MANUAL] Verify Order ##{card_order_id}",
          from: "orders@lulcards.com",
          to: ENV["MANUAL_NOTIFY_EMAIL_ADDRESS"],
          body_text: ""
        ) rescue nil
      end
    end

    true
  end

  def try_manual_parsing_birthday_for_request(birthday_request_id)
    queue_name = "#{queue_prefix}-manual-birthday-parse"
    payload = { birthday_request_id: birthday_request_id, task_token: self.task_token }
    AWS::SQS.new.queues.named(queue_name).send_message(payload.to_json)

    if ENV["MANUAL_NOTIFY_EMAIL_ADDRESS"]
      if rand() <= CONFIG.birthday_request_admin_notify
        AWS::SimpleEmailService.new.send_email(
          subject: "[POSTO MANUAL] Birthday Request ##{birthday_request_id}",
          from: "orders@lulcards.com",
          to: ENV["MANUAL_NOTIFY_EMAIL_ADDRESS"],
          body_text: ""
        ) rescue nil
      end
    end

    true
  end
end
