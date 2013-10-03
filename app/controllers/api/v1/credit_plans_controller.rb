module Api
  module V1
    class CreditPlansController < ApplicationController
      include ApiSecureEndpoint

      def destroy
        app = App.by_name(params[:app_id])
        @current_user.credit_plan_membership_for_app(app).cancel!

        respond_to do |format|
          format.json { render json: { } }
        end
      end
    end
  end
end
