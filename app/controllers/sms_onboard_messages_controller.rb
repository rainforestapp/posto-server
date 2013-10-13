class SmsOnboardMessagesController < ApplicationController
  def create
    @app = App.by_name(params[:app_id])
    success = false

    if @app
      @app.send_sms!(to: params[:destination], type: :onboard)
      success = true
    end

    respond_to do |format|
      format.json do
        render json: { success: success }
      end
    end
  end
end
