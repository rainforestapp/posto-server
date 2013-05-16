module Api
  module V1
    class AddressesController < ApplicationController
      #include ApiSecureEndpoint # TODO race condition in app causing token to not be in there :P

      def show
        unless params[:q]
          head :bad_request
          return
        end

        address_api_response = AddressApiResponse.lookup(params[:q])
        api_result = address_api_response.try(:response) || {}

        respond_to do |format|
          format.json do 
            if api_result.keys.size > 0
              address = {}
              address[:line_1] = api_result["delivery_line_1"]
              address[:line_2] = api_result["delivery_line_2"] || api_result["last_line"]
              address[:line_3] = api_result["last_line"] if api_result["delivery_line_2"]
              address[:location] = api_result["components"]["city_name"] + ", " + api_result["components"]["state_abbreviation"]

              render json: { success: true, address: address, address_api_response_id: address_api_response.address_api_response_id }
            else
              render json: { success: false }
            end
          end
        end
      end
    end
  end
end
