module Api
  module V1
    class UsersController < ApplicationController
      def show
        respond_to do |format|
          facebook_id = params[:id]

          recipient = {
            facebook_id: facebook_id,
            address_request_required: true,
          }

          user = User.where(:facebook_id => facebook_id).first

          if user
            recipient[:user_id] = user.user_id 
            recipient[:address_request_required] = user.requires_address_request?
          end

          format.json do
            render :json => recipient
          end
        end
      end
    end
  end
end
