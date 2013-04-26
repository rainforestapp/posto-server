module Api
  module V1
    class ShareController < ApplicationController
      include ApiSecureEndpoint

      def create
        card_order = CardOrder.find(params[:card_order_id])
        card_order.execute_share_workflow! if Rails.env == "production"

        respond_to do |format|
          format.json { render json: { card_order_id: card_order.card_order_id } }
        end
      end
    end
  end
end
