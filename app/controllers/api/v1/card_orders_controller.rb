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
          payload = JSON.parse(payload)

          is_promo = params[:promo] == "true"
          create_order = true

          # Hack to delay promo card if user upload failed
          if is_promo && !payload["card_design"]["composed_full_photo"]
            if payload["recipients"].try(:size) == 1
              address_api_response_id = payload["recipients"][0]["supplied_address_api_response_id"]

              if address_api_response_id
                DelayedPromoCard.create(user_id: @current_user.user_id,
                                        supplied_address_api_response_id: address_api_response_id)
              end
            end

            create_order = false
          end

          # Remove caption on promo cards
          if is_promo
            payload["card_design"]["composed_full_photo"] = payload["card_design"]["edited_full_photo"] || payload["card_design"]["original_full_photo"] 
          end

          if create_order 
            order = @current_user.create_order_from_payload!(payload, is_promo: is_promo)

            order.execute_workflow! if Rails.env == "production"
          end
        end

        respond_to do |format|
          format.json { render json: { card_order_id: order.try(:card_order_id) } }
        end
      end
    end
  end
end
