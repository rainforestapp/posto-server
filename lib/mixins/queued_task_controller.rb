module QueuedTaskController
  extend ActiveSupport::Concern

  included do
    http_basic_authenticate_with name: "admin", password: ENV["POSTO_ADMIN_PASSWORD"]
    cattr_accessor :queue_to_consume
  end

  module ClassMethods
    def consumes_queue(name)
      self.queue_to_consume = "posto-#{Rails.env == "production" ? "prod" : "dev"}-#{name.to_s.gsub("_", "-")}"
    end
  end
end
