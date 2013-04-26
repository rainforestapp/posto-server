module QueuedTaskController
  extend ActiveSupport::Concern

  included do
    cattr_accessor :queue_to_consume
  end

  def destroy
    raise "missing task token" unless params[:task_token]
    complete_swf_activity_task!
    redirect_to action: :new
  end

  def new
    sqs = AWS::SQS.new
    queue = AWS::SQS.new.queues.named(self.class.queue_to_consume)
    message = queue.receive_message(limit: 1,
                                    wait_time_seconds: 1)

    if message
      data = JSON.parse(message.body)
      task_token = data["task_token"]
      message.delete

      if data["address_request_id"]
        address_request = AddressRequest.find(data["address_request_id"])
        redirect_to admin_address_request_path address_request, task_token: task_token
      elsif data["birthday_request_id"]
        birthday_request = BirthdayRequest.find(data["birthday_request_id"])
        redirect_to admin_birthday_request_path birthday_request, task_token: task_token
      elsif data["card_order_id"]
        card_order = CardOrder.find(data["card_order_id"])
        redirect_to admin_card_order_path card_order, task_token: task_token
      else
        raise "Unknown task type #{data}"
      end
    end
  end

  module ClassMethods
    def consumes_queue(name)
      self.queue_to_consume = "posto-#{Rails.env == "production" ? "prod" : "dev"}-#{name.to_s.gsub("_", "-")}"
    end
  end
end
