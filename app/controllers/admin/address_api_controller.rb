module Admin
  class AddressApiController < AdminControllerBase
    def show
      record = AddressApiResponse.lookup(params[:q])

      respond_to do |format|
        format.json do
          render json: {
            address_api_response_id: record.address_api_response_id,
            data: record.response
          } 
        end
      end
    end
  end
end
