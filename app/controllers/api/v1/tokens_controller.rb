require_dependency "api_key"
require_dependency "user"

module Api
  module V1
    class TokensController < ApplicationController
      respond_to :json

      TOKEN_CACHE_KEY_PREFIX = :api_key_by_token_with_user_2

      def self.clear_token_cache_for_user_id(user_id)
        ApiKey.where(user_id: user_id).each do |api_key|
          Rails.cache.delete([TOKEN_CACHE_KEY_PREFIX, api_key.token])
        end
      end

      def create
        token = params[:posto_token]
        facebook_token = params[:facebook_token]

        api_key = nil

        unless token.blank?
          api_key = Rails.cache.fetch([TOKEN_CACHE_KEY_PREFIX, token]) do
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

        current_facebook_token = nil

        unless api_key.try(:active?)
          STATSD.increment("controller.all.tokens.create_token.count")

          User.transaction_with_retry do
            user = nil

            STATSD.time("controller.all.tokens.user_create_time") do
              user = User.first_or_create_with_facebook_token(facebook_token)
            end

            current_facebook_token = facebook_token

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
          if facebook_token && current_facebook_token != facebook_token
            user_id = api_key.user_id

            current_facebook_token = FacebookToken.current_facebook_token_for_user_id(user_id)

            if current_facebook_token != facebook_token
              FacebookToken.create!(user_id: user_id, token: facebook_token)
            end
          end

          @api_key = api_key
          respond_with(@api_key)
        else
          head :unauthorized
        end
      end
    end
  end
end
