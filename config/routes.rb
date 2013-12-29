OfficeClerk::Application.routes.draw do
  match "purchases/search_and_filter" => "purchases#index", :via => [:get, :post], :as => :search_purchases
  resources :purchases do
    collection do
      post :batch
    end
    member do
    end
  end

  match "baskets/search_and_filter" => "baskets#index", :via => [:get, :post], :as => :search_baskets
  resources :baskets do
    collection do
      post :batch
    end
    member do
    end
  end

  match "orders/search_and_filter" => "orders#index", :via => [:get, :post], :as => :search_orders
  resources :orders do
    collection do
      post :batch
    end
    member do
    end
  end

  match "items/search_and_filter" => "items#index", :via => [:get, :post], :as => :search_items
  resources :items do
    collection do
      post :batch
    end
    member do
    end
  end

  match "product_groups/search_and_filter" => "product_groups#index", :via => [:get, :post], :as => :search_product_groups
  resources :product_groups do
    collection do
      post :batch
    end
    member do
    end
  end

  match "products/search_and_filter" => "products#index", :via => [:get, :post], :as => :search_products
  resources :products do
    collection do
      post :batch
    end
    member do
    end
  end

  match "users/search_and_filter" => "users#index", :via => [:get, :post], :as => :search_users
  resources :users do
    collection do
      post :batch
    end
    member do
    end
  end

  match "addresses/search_and_filter" => "addresses#index", :via => [:get, :post], :as => :search_addresses
  resources :addresses 

  match "suppliers/search_and_filter" => "suppliers#index", :via => [:get, :post], :as => :search_suppliers
  resources :suppliers do
    collection do
      post :batch
    end
    member do
    end
  end

  root :to => 'beautiful#dashboard'
  match ':model_sym/select_fields' => 'beautiful#select_fields', :via => [:get, :post]

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end