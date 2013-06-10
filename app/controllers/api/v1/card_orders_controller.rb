module Api
  module V1
    class CardOrdersController < ApplicationController
      include ApiSecureEndpoint

      def create
        order = nil

        CardOrder.transaction_with_retry do
          payload = params[:payload]
          encoding_options = { invalid: :replace, undef: :replace, replace: "" }
          payload = payload.encode Encoding.find('ASCII'), encoding_options

          order = @current_user.create_order_from_payload!(JSON.parse(payload))
          order.execute_workflow! if Rails.env == "production"
        end

        respond_to do |format|
          format.json { render json: { card_order_id: order.card_order_id } }
        end
      end
    end
  end
end
