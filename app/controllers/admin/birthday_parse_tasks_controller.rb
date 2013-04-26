class Admin::BirthdayParseTasksController < AdminControllerBase
  include QueuedTaskController

  consumes_queue :manual_birthday_parse
end
