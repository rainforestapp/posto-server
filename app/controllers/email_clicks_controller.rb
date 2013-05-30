class EmailClicksController < ApplicationController
  layout "gift"

  def show
    @task = OutgoingEmailTask.where(uid: params[:id]).first
    @app = @task.app

    if request.user_agent =~ /Mobile/
      @task.state = :opened
      redirect_to CONFIG.for_app(@app).reminder_app_url
    else
      @task.state = :clicked
      render
    end
  end
end
