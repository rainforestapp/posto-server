class AdminControllerBase < ApplicationController
  layout "admin"

  http_basic_authenticate_with name: "admin", password: ENV["POSTO_ADMIN_PASSWORD"]
end
