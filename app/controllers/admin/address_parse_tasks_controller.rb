class Admin::AddressParseTasksController < ApplicationController
  include QueuedTaskController

  consumes_queue :manual_address_parse

  def new
    sqs = AWS::SQS.new
    queue = AWS::SQS.new.queues.named(self.class.queue_to_consume)
    message = queue.receive_message(limit: 1,
                                    wait_time_seconds: 1)

    if message
      message.delete
    end
  end
end
