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

          # Handle new user, the way we know is if their credit journal is empty.
          
          if @config.signup_credits <= 0
            # Signup credits has to be > 0 right now, because the check below is used to determine if this user 
            # was just created. If so, the bonuses are handles below. If signup credits is zero, then no journal
            # entry will be created and the bonuses will not be applied (referrals). So, if signup credits becomes
            # zero we need another way to know when this is the first time the user was accessed by the app.
            raise "Must have signup credits -- see code comment"
          end

          if @current_user.has_empty_credit_journal_for_app?(app)
            @current_user.handle_signup_bonuses_for_app!(app)
            @granted_initial_credits = true
          end
        end

        respond_with(@current_user)
      end
    end
  end
end
