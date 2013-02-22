class Admin::VerifyOrderTasksController < AdminControllerBase
  include QueuedTaskController

  consumes_queue :manual_verify_order
end
