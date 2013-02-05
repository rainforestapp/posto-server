module Api
  module V1
    class CurrentUserController < ApplicationController
      include ApiSecureEndpoint

      respond_to :json

      def index
        respond_with(@current_user)
      end
    end
  end
end
