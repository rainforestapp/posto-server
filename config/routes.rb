require "api_constraints"

Posto::Application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :tokens
      resource :current_user, controller: "CurrentUser" do
        resource :payment_info do
          resources :tokens, controller: "PaymentToken"
        end
      end

      resources :config, controller: "Conf"
      resources :photo_upload_tokens

      resource :users do
        resources :facebook, controller: "Users"
      end
    end
  end
end
