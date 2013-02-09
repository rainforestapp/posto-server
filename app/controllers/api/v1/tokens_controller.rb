module Api
  module V1
    class TokensController < ApplicationController
      respond_to :json

      def create
        token = params[:posto_token]
        facebook_token = params[:facebook_token]

        api_key = token && ApiKey.where(:token => token).first

        if api_key
          if api_key.expired?
            api_key = nil
          elsif api_key.renewable?
            api_key = api_key.user.renew_api_key!
          end
        end

        unless api_key.try(:active?)
          user = User.first_or_create_with_facebook_token(facebook_token)

          if user
            api_key = user.renew_api_key!
          end
        end

        if api_key
          @api_key = api_key
          api_key.user.add_login!
          respond_with(@api_key)
        else
          head :unauthorized
        end
      end
    end
  end
end
