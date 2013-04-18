module Api
  module V1
    class BirthdayController < ApplicationController
      include ApiSecureEndpoint

      def create
        birthday = params[:birthday]
        return head :bad_request unless birthday

        begin
          birthday = Chronic.parse(birthday + " 00:00:00")
        rescue Exception => e
          return head :bad_request
        end

        return head :bad_request unless params[:facebook_id]

        # TODO bit of a security hole since anyone can set this even non-friends.
        # punted for now since always falls back on profile birthday
        # and worst case scenario is someone has the wrong birthday.

        User.transaction_with_retry do
          user = User.where(facebook_id: params[:facebook_id]).first_or_create!
          user.birthday_request_responses.create!(birthday: birthday,
                                                  sender_user_id: @current_user.user_id)
        end

        respond_to do
          format.json do
            render json: { user_id: user.user_id, birthday: user.birthday }
          end
        end
      end
    end
  end
end
