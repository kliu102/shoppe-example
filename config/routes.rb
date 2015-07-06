Rails.application.routes.draw do

  #
  # Shoppe admin interface
  #
  # mount Shoppe::Engine => "/shoppe"

  namespace :shoppe do
    get 'attachment/:id/:filename.:extension' => 'attachments#show'
    resources :product_categories
    resources :products do
      resources :variants
      collection do
        get :import
        post :import
      end
    end
    resources :orders do
      collection do
        post :search
      end
      member do
        post :accept
        post :reject
        post :ship
        get :despatch_note
      end
      resources :payments, :only => [:create, :destroy] do
        match :refund, :on => :member, :via => [:get, :post]
      end
    end
    resources :stock_level_adjustments, :only => [:index, :create]
    resources :delivery_services do
      resources :delivery_service_prices
    end
    resources :tax_rates
    resources :users
    resources :countries
    resources :attachments, :only => :destroy

    get 'settings'=> 'settings#edit'
    post 'settings' => 'settings#update'

    get 'login' => 'sessions#new'
    post 'login' => 'sessions#create'
    match 'login/reset' => 'sessions#reset', :via => [:get, :post]

    delete 'logout' => 'sessions#destroy'
    root :to => 'dashboard#home'
  end

  #
  # Product browising
  #
  get 'products' => 'products#categories', :as => 'catalogue'
  get 'products/filter' => 'products#filter', :as => 'product_filter'
  get 'products/:category_id' => 'products#index', :as => 'products'
  get 'products/:category_id/:product_id' => 'products#show', :as => 'product'
  post 'products/:category_id/:product_id/buy' => 'products#add_to_basket', :as => 'buy_product'
  
  #
  # Order status
  #
  get 'order/:token' => 'orders#status', :as => 'order_status'

  #
  # Basket
  #
  get 'basket' => 'orders#show', :as => 'basket'
  delete 'basket' => 'orders#destroy', :as => 'empty_basket'
  post 'basket/:order_item_id' => 'orders#change_item_quantity', :as => 'adjust_basket_item_quantity'
  delete 'basket/:order_item_id' => 'orders#change_item_quantity'
  delete 'basket/delete/:order_item_id' => 'orders#remove_item', :as => 'remove_basket_item'
  
  #
  # Checkout
  #
  match 'checkout' => 'orders#checkout', :as => 'checkout', :via => [:get, :patch]
  match 'checkout/delivery' => 'orders#change_delivery_service', :as => 'change_delivery_service', :via => [:post]
  match 'checkout/pay' => 'orders#payment', :as => 'checkout_payment', :via => [:get, :patch]
  match 'checkout/confirm' => 'orders#confirmation', :as => 'checkout_confirmation', :via => [:get, :patch]
  
  #
  # Static pages
  #
  get ':action', :controller => 'pages', :as => 'page'
  
  # 
  # Homepage
  #
  root :to => 'pages#home'
  
end
