module Api
  module V1
    class ConfController < ApplicationController
      def show
        config_seed = params[:id] || 0
        config = CONFIG.to_sampled_config(config_seed.to_i)
        expires_in 5.minutes, public: true

        respond_to do |format|
          format.json do
            render json: config
          end
        end
      end
    end
  end
end
