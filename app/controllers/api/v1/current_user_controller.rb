module Api
  module V1
    class CurrentUserController < ApplicationController
      include ApiSecureEndpoint

      respond_to :json

      def show
        @granted_initial_credits = false

        if params[:app_id]
          app = App.by_name(params[:app_id])
          return head :bad_request unless app
          @config = CONFIG.for_app(app)

          # Current user may be a stale cached copy
          unless @current_user.signup_credits_awarded
            @current_user.reload

            unless @current_user.signup_credits_awarded
              @current_user.handle_signup_bonuses_for_app!(app)
              @current_user.signup_credits_awarded = true
              @current_user.save
              Api::V1::TokensController.clear_token_cache_for_user_id(@current_user.user_id)

              if @current_user.credits_for_app(app) > 0
                @granted_initial_credits = true
              end
            end
          end
        end

        respond_with(@current_user)
      end
    end
  end
end
