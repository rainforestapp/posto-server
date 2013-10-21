module Api
  module V1
    class PostcardSubjectsController < ApplicationController
      include ApiSecureEndpoint

      respond_to :json

      def create
        postcard_subjects = params[:postcard_subjects]
        app = params[:app]

        return head :bad_request unless postcard_subjects && app

        app = App.by_name(app)

        return head :bad_request unless app

        postcard_subjects = JSON.parse(postcard_subjects)

        return head :bad_request unless @current_user

        postcard_subjects.each(&:symbolize_keys!)

        @current_user.set_postcard_subjects(postcard_subjects, app: app)

        render json: @current_user.postcard_subjects.select { |s| s.state == :active }
      end
    end
  end
end
