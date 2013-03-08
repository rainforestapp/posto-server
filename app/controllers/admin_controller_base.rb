class AdminControllerBase < ApplicationController
  include ForceSsl

  layout "admin"

  http_basic_authenticate_with name: "admin", password: ENV["POSTO_ADMIN_PASSWORD"]

  def complete_swf_activity_task!
    AWS::SimpleWorkflow::Client.new().respond_activity_task_completed(:task_token => params[:task_token], 
                                                                      :result => params[:task_result].to_json)
  end
end
