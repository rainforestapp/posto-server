require "api_constraints"

Posto::Application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :tokens
      resource :current_user, controller: "CurrentUser"
      resource :config, controller: "Conf"
    end
  end
end
