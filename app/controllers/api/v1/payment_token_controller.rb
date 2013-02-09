module Api
  module V1
    class PaymentTokenController < ApplicationController
      include ApiSecureEndpoint

      respond_to :json

      def create
        token = params[:token]

        if token
          error = nil

          begin
            @current_user.set_stripe_payment_info_with_token(token)
          rescue StripeCvcCheckFailException => e
            error = :cvc
          rescue Stripe::InvalidRequestError => e
            error = :stripe
          end

          unless error
            @stripe_customer = @current_user.stripe_customer
            respond_with(@stripe_customer)
          else
            if error == :unknown
              head :bad_request
            else
              respond_to do |format|
                format.json { render json: { error: error } }
              end
            end
          end
        else
          head :bad_request
        end
      end
    end
  end
end
