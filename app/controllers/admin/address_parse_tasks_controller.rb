class Admin::AddressParseTasksController < AdminControllerBase
  include QueuedTaskController

  consumes_queue :manual_address_parse
end
