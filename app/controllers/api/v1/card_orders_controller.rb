module Api
  module V1
    class CardOrdersController < ApplicationController
      include ApiSecureEndpoint

      def index
        app = App.by_name(params[:app_id])
        @card_orders = CardOrder.where(order_sender_user_id: @current_user.user_id, app_id: app.app_id).includes(
          :card_order_states, 
          card_design: [ :original_full_photo_image, :edited_full_photo_image, 
                         :composed_full_photo_image, { card_preview_compositions: :treated_card_preview_image }], 
          card_printings: [{recipient_user: :user_profiles }]) 
      end

      def create
        order = nil

        CardOrder.transaction_with_retry do
          payload = params[:payload]
          encoding_options = { invalid: :replace, undef: :replace, replace: "" }
          payload = payload.encode Encoding.find('ASCII'), encoding_options

          order = @current_user.create_order_from_payload!(JSON.parse(payload), is_promo: params[:promo] == "true")
          order.execute_workflow! if Rails.env == "production"
        end

        respond_to do |format|
          format.json { render json: { card_order_id: order.card_order_id } }
        end
      end
    end
  end
end
