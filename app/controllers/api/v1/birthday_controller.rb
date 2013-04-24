module Api
  module V1
    class BirthdayController < ApplicationController
      def show
        return head :bad_request unless params[:facebook_id]
        
        facebook_ids = params[:facebook_id].split(",")

        birthdays = facebook_ids.map do |facebook_id|
          { facebook_id: facebook_id,
            birthday: User.birthday_for_facebook_id(facebook_id), }
        end

        respond_to do |format|
          format.json do
            render json: { birthdays: birthdays }
          end
        end
      end
    end
  end
end
