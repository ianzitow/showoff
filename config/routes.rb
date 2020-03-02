Rails.application.routes.draw do
  root to: 'static#index'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Authentication
      post 'authentication/create'
      post 'authentication/revoke'
      post 'authentication/refresh'
      # Users
      post 'users/create'
      put 'users/update'
      get 'users/:id', to: 'users#show'
      post 'users/change_password'
      get 'users/check_email'
      post 'users/reset_password'
      get 'users/:id/widgets', to: 'widgets#index'
      # Widgets
      namespace :widgets do
        get 'visible', to: 'visible#index'
      end
      post 'widgets/create'
      put 'widgets/:id', to: 'widgets#update'
      get 'widgets/show'
      delete 'widgets/:id', to: 'widgets#destroy'
    end
  end
  get '*page', to: 'static#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
