module Api
  module V1
    class CurrentUserController < ApplicationController
      include ApiSecureEndpoint

      respond_to :json

      def show
        @granted_initial_credits = false

        
        if params[:app_id]
          app = App.by_name(params[:app_id])
          return head :bad_request unless app

          if CONFIG.signup_credits > 0 &&
            @current_user.has_empty_credit_journal_for_app?(app)

            User.transaction_with_retry do
              if @current_user.has_empty_credit_journal_for_app?(app)
                @current_user.add_credits!(CONFIG.signup_credits,
                                           app: app,
                                           source_type: :signup,
                                           source_id: @current_user.user_id)

                @granted_initial_credits = true
              end
            end
          end
        end

        respond_with(@current_user)
      end
    end
  end
end
