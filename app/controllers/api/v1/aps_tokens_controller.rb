module Api
  module V1
    class ApsTokensController < ApplicationController
      include ApiSecureEndpoint

      def create
        token = params[:token]
        app = App.by_name(params[:app])
        aps_token_record = @current_user.aps_tokens.where(app_id: app.app_id).first

        unless aps_token_record.try(:token) == token
          @current_user.aps_tokens.create!(app: app, token: token)

          Urbanairship.register_device(token,
                                       alias: "#{app.name}-#{Rails.env}-user-#{@current_user.user_id}",
                                       tags: ["posto", "app-#{app.name}", "env-#{Rails.env}"])
        end

        respond_to do |format|
          format.json { render json: { token: token } }
        end
      end
    end
  end
end
