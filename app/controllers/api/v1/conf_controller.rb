module Api
  module V1
    class ConfController < ApplicationController
      def show
        config_id = params[:id]

        respond_to do |format|
          format.json do
            render :json => {}
          end
        end
      end
    end
  end
end
