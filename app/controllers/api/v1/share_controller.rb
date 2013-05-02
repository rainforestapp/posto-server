module Api
  module V1
    class ShareController < ApplicationController
      include ApiSecureEndpoint

      def create
        card_order = CardOrder.find(params[:card_order_id])
        bind_to_app!(card_order.app)
        card_order.days_until_share = @config.open_graph_share_delay_days
        card_order.save!

        respond_to do |format|
          format.json { render json: { card_order_id: card_order.card_order_id } }
        end
      end
    end
  end
end
