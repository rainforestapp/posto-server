require "api_constraints"

Posto::Application.routes.draw do
  mount RailsAdmin::Engine => '/radmin', :as => 'rails_admin'

  root to: "index#show"

  resources :qr, controller: "Qr"
  resources :ref, controller: "Ref"
  resources :v, controller: "ShareRedirect"

  resources :card_printings
  resource :channel
  resource :launch_faq, controller: "LaunchFaq"
  resources :email_clicks
  resources :unsubscribes

  resources :apps do
    resource :signup
    resource :promo
    resources :gift_credits
    resources :sms_onboard_messages
    resources :birthday_gift_credits
  end

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :tokens

      resource :current_user, controller: "CurrentUser" do
        resource :payment_info do
          resources :tokens, controller: "PaymentToken"
        end

        resources :card_orders do
          resource :share, controller: "Share"
        end

        resources :aps_tokens
        resources :credit_orders
        resources :postcard_subjects
      end

      resources :apps do
        resource :current_user, controller: "CurrentUser" do
          resources :birthday_reminders
          resources :card_orders
          resource :credit_plan
        end

        resources :config, controller: "Conf"
      end

      resources :photo_upload_tokens

      resource :users do
        resources :facebook, controller: "Users" do
          resource :birthday, controller: "Birthday"
        end

        resources :contact, controller: "Users" do
          resource :birthday, controller: "Birthday"
        end
      end

      resource :addresses
    end
  end

  resource :admin, controller: "Admin" do
    scope module: :admin do
      resources :address_parse_tasks, :birthday_parse_tasks, :verify_order_tasks, 
                :birthday_requests, :address_requests, :card_orders, :promo_codes

      resource :address_api, controller: "AddressApi"

      match 'mailer(/:action(/:id(.:format)))' => 'mailer#:action'
    end
  end
end
