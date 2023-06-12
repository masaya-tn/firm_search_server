Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :firms do
    collection do
      get 'search'
    end
  end
end
