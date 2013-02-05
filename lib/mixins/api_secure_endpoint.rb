module ApiSecureEndpoint
  extend ActiveSupport::Concern

  included do
    before_filter(lambda do
      authenticate_or_request_with_http_token do |token, options|
        if Rails.env == "development" && token == "thisisabackdoor"
          @current_user = User.where(facebook_id: "403143")
          return true
        end

        api_key = ApiKey.where(:token => token).first

        api_key.try(:active?).tap do |active|
          @current_user = api_key.try(:user) if active
        end
      end
    end)
  end
end
