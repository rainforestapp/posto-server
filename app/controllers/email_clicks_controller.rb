class EmailClicksController < ApplicationController
  layout "gift"

  def show
    @task = OutgoingEmailTask.where(uid: params[:id]).first
    @app = @task.app

    if @task
      if params[:display]
        @task.state = :opened
        redirect_to "http://s3-us-west-1.amazonaws.com/posto-assets/pixel.png"
      else
        @task.state = :clicked

        if mobile_agent?
          redirect_to CONFIG.for_app(@app).reminder_app_url
        else
          render
        end
      end
    else
      render
    end
  end
end
