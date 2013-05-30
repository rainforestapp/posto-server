class UnsubscribesController < ApplicationController
  def show
    @task = OutgoingEmailTask.where(uid: params[:id]).first
    @app = @task.app
    @task.recipient_user.opt_out_of_email_class!(OutgoingEmailTask::EMAIL_CLASS_MAP[@task.email_type])
    render text: "You have been unsubscribed."
  end
end
