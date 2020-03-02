Rails.application.routes.draw do
  resources :home, only: :index
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
      # Widgets
      post 'widgets/create'
      put 'widgets/:id', to: 'widgets#update'
      get 'widgets/show'
      delete 'widgets/:id', to: 'widgets#destroy'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
