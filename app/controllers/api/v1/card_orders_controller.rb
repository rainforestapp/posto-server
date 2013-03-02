module Api
  module V1
    class CardOrdersController < ApplicationController
      include ApiSecureEndpoint

      def create
        order = @current_user.create_order_from_payload!(JSON.parse(params[:payload]))
        order.execute_workflow! if Rails.env == "production"

        respond_to do |format|
          format.json { render json: { card_order_id: order.card_order_id } }
        end
      end
    end
  end
end
