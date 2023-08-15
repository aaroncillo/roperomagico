Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Defines the root path route ("/")
  # root "articles#index"

  resources :companies, only: [:index, :new, :create] do
    get 'balances', to: 'companies#balances'
    resources :clients, only: [:index, :new, :create]
  end
  resources :clients, except: [:index, :new, :create] do
    member do
      get :export_all_csv
    end
    resources :products, only: [:index, :new, :create]
  end
  resources :companies, except: [:index, :new, :create]
  resources :products, except: [:index, :new, :create]

  resources :import do
    collection do
      post :import
    end
  end

  get 'morosos', to: 'companies#morosos'

end
