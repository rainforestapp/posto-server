module ForceSsl
  extend ActiveSupport::Concern

  included do
    before_filter(lambda do
      if Rails.env == "production"
        unless request.ssl?
          head :forbidden
        end
      end
    end)
  end
end
