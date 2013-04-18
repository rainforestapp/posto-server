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

  resources :apps do
    resource :signup
    resource :promo
  end

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :tokens

      resource :current_user, controller: "CurrentUser" do
        resource :payment_info do
          resources :tokens, controller: "PaymentToken"
        end

        resources :card_orders
        resources :aps_tokens
        resources :credit_orders
      end

      resources :apps do
        resource :current_user, controller: "CurrentUser"
        resources :config, controller: "Conf"
      end

      resources :photo_upload_tokens

      resource :users do
        resources :facebook, controller: "Users" do
          resource :birthday, controller: "Birthday"
        end
      end

      resource :addresses
    end
  end

  resource :admin, controller: "Admin" do
    scope module: :admin do
      resources :address_parse_tasks, :verify_order_tasks, 
                :address_requests, :card_orders, :promo_codes

      resource :address_api, controller: "AddressApi"

      match 'mailer(/:action(/:id(.:format)))' => 'mailer#:action'
    end
  end
end
