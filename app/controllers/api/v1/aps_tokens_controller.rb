module Api
  module V1
    class ApsTokensController < ApplicationController
      include ApiSecureEndpoint

      def create
        token = params[:aps_token]
        app = App.by_name(params[:app])
        aps_token_record = @current_user.aps_tokens.where(app: app)

        unless aps_token_record.try(:token) == token
          @current_user.aps_tokens.where(app: app).create!(token: token)

          Urbanairship.register_device(token,
                                       alias: "#{app.name}-user-#{@current_user.user_id}",
                                       tags: ["posto", "app-#{app.name}", "env-#{Rails.env}"])
        end

        respond_to do |format|
          format.json { render json: { token: token } }
        end
      end
    end
  end
end
