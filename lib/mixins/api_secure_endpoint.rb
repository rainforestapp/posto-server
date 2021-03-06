require_dependency "api_key"
require_dependency "user"

module ApiSecureEndpoint
  extend ActiveSupport::Concern

  included do
    cattr_accessor :__auth_token_optional

    skip_before_filter :verify_authenticity_token, if: lambda { |c| c.request.format == 'application/json' }

    before_filter(lambda do
      if Rails.env == "production"
        unless self.class.__auth_token_optional && request.env["Authorization"].nil?
          unless request.ssl?
            head :forbidden
          end
        end
      end
    end)

    before_filter(lambda do
      return true if self.class.__auth_token_optional && request.env["Authorization"].nil?

      authenticate_or_request_with_http_token do |token, options|
        #if Rails.env == "development" && token == "thisisabackdoor"
        #  @current_user = User.where(facebook_id: "403143").first
        #  return true
        #end

        api_key = Rails.cache.fetch([Api::V1::TokensController::TOKEN_CACHE_KEY_PREFIX, token]) do
          ApiKey.where(token: token).includes(:user).first
        end

        authenticated = api_key.try(:active?).tap do |active|
          @current_user = api_key.try(:user) if active
          logger.info "Request Authenticated as [#{@current_user.user_id}]" if @current_user
        end

        authenticated || self.class.__auth_token_optional
      end
    end)

    def self.allow_unauthenticated_access!
      self.__auth_token_optional = true
    end
  end
end
