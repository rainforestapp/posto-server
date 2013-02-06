module Api
  module V1
    class ConfController < ApplicationController
      def show
        respond_to do |format|
          format.json do
            render :json => @sampled_config || {}
          end
        end
      end
    end
  end
end
