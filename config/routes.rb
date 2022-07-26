Rails.application.routes.draw do
  devise_for :clients
  devise_for :admins, path: 'admins'

  root 'products#index'

  resources :promotions, only: %i[new create index show]
  resources :categories, only: %i[new create index show] do
    post 'activate', on: :member
    post 'deactivate', on: :member
  end
  resources :products, only: %i[new create show] do
    get 'search', on: :collection
    get 'filter', on: :collection
    post 'activate', on: :member
    post 'deactivate', on: :member
    patch 'update_cashback', on: :member
    resources :product_items, only: %i[create destroy] do
      patch 'sum_quantity', on: :member
      patch 'dec_quantity', on: :member
    end
    resources :reviews, only: %i[new create]
  end
  resources :prices, only: :create
  resources :cashbacks, only: %i[index new create]

  get 'shopping_cart', to: 'shopping_cart#index'
  resources :purchases, only: %i[index create] do
    get 'search', on: :collection
  end

  resources :pending_admins, only: %i[index] do
    post 'approve', on: :member
  end

  resources :stock_products, only: %i[index] do
    patch 'change', on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :exchange_rates, only: %i[create]

      post 'clients/update-balance', to: 'clients#update_balance'

      post 'purchases/update-status', to: 'purchases#update_status'
    end
  end
end
