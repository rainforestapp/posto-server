module Api
  module V1
    class UsersController < ApplicationController
      def show
        respond_to do |format|
          # Nasty bit for backwards compatibility
          return_array = params[:id].include?(",") || params[:multi]
          facebook_ids = params[:id].split(",")

          existing_users = User.where(facebook_id: facebook_ids)
                               .includes(:recipient_addresses, :user_profiles, :birthday_request_responses).to_a

          recipients = facebook_ids.map do |facebook_id|
            {
              facebook_id: facebook_id,
              address_request_required: true,
              birthday_request_required: true,
            }.tap do |recipient|
              user = existing_users.find { |u| u.facebook_id == facebook_id }

              if user
                recipient[:user_id] = user.user_id 
                recipient[:birthday] = user.birthday

                recipient[:address_request_required] = user.requires_address_request?
                recipient[:birthday_request_required] = user.requires_birthday_request?
                recipient[:has_address] = user.has_up_to_date_address?

                if user.recipient_address
                  recipient[:location] = "#{user.recipient_address.city}, #{user.recipient_address.state}"
                end
              end
            end
          end

          format.json do
            render :json => return_array ? recipients : recipients.first
          end
        end
      end
    end
  end
end
