Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }

  namespace :auth do
    resources :sessions, only: %i[index]
  end
  
  resources :firms do
    collection do
      get 'search'
    end
  end
end
