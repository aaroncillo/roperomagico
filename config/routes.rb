Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Defines the root path route ("/")
  # root "articles#index"

  resources :companies, only: [:index, :new, :create] do
    resources :clients, only: [:index, :new, :create] do
      resources :products, only: [:index, :new, :create]
    end
  end
  resources :clients, except: [:index, :new, :create]
  resources :companies, except: [:index, :new, :create]
end
