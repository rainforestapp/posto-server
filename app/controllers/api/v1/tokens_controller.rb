require_dependency "api_key"
require_dependency "user"

module Api
  module V1
    class TokensController < ApplicationController
      respond_to :json

      def create
        token = params[:posto_token]
        facebook_token = params[:facebook_token]

        api_key = nil

        unless token.blank?
          api_key = Rails.cache.fetch([:api_key_by_token, token]) do
            ApiKey.where(token: token).includes(:user).first
          end
        end

        if api_key
          if api_key.expired?
            api_key = nil
          elsif api_key.renewable?
            api_key = api_key.user.renew_api_key!
          end
        end

        unless api_key.try(:active?)
          User.transaction_with_retry do
            user = User.first_or_create_with_facebook_token(facebook_token)

            if user
              first_login_key = [:user_has_first_login, user]

              has_first_login = Rails.cache.fetch(first_login_key) do
                user.user_logins.size > 0
              end

              unless has_first_login
                if user.user_logins.size == 0
                  user.add_login!
                  Rails.cache.delete(first_login_key)
                end
              end

              api_key = user.renew_api_key!
            end
          end
        end

        if api_key
          @api_key = api_key
          respond_with(@api_key)
        else
          head :unauthorized
        end
      end
    end
  end
end
