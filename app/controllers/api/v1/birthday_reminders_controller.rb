module Api
  module V1
    class BirthdayRemindersController < ApplicationController
      include ApiSecureEndpoint

      respond_to :json

      def create
        reminders = params[:reminders]
        return head :bad_request unless reminders

        app = App.by_name(params[:app_id])
        message = params[:message]
        return head :bad_request unless message

        reminders = JSON.parse(reminders)

        User.transaction_with_retry do
          @current_user.set_birthday_reminders(reminders, app: app, message: message)
        end

        respond_to do
          format.json do
            render json: { status: :ok }
          end
        end
      end
    end
  end
end
