module Api
  module V1
    class BirthdayRemindersController < ApplicationController
      include ApiSecureEndpoint

      respond_to :json

      def create
        payload = params[:payload]
        return head :bad_request unless payload

        app = App.by_name(params[:app_id])
        return head :bad_request unless app

        reminders = JSON.parse(payload)["reminders"]
        return head :bad_request unless reminders

        reminders.each(&:symbolize_keys!)

        User.transaction_with_retry do
          @current_user.set_birthday_reminders(reminders, app: app)
        end

        respond_to do |format|
          format.json do
            render json: { status: :ok }
          end
        end
      end
    end
  end
end
