module Api
  module V1
    class ApsTokensController < ApplicationController
      include ApiSecureEndpoint

      def create
        token = params[:token]
        app = App.by_name(params[:app])
        aps_token_record = @current_user.aps_tokens.where(app_id: app.app_id).first
        
        CONFIG.for_app(app) do |config|
          unless aps_token_record.try(:token) == token
            @current_user.aps_tokens.create!(app: app, token: token)

            urban_airship = Urbanairship::Client.new
            urban_airship.application_key = config.urban_airship_application_key
            urban_airship.application_secret = config.urban_airship_application_secret
            urban_airship.master_secret = config.urban_airship_master_secret
            urban_airship.logger = Rails.logger
            urban_airship.request_timeout = 5

            urban_airship.register_device(token,
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
end
