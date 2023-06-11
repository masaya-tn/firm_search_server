Rails.application.routes.draw do
  resources :firms do
    collection do
      get 'search'
    end
  end
end
