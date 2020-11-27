Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }
  devise_scope :user do
    get 'destination', to: 'users/registrations#new_destination'
    post 'destination', to: 'users/registrations#create_destination'
    get 'logout', to: 'users/sessions#logout'
  end
  root 'products#index'
  resources :products, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do
      get :search
      get :pay
      get :check
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
    member do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
  end
  
  resources :users, only: [:show, :edit] do
    resources :credit_cards, only: [:new, :create, :show, :destroy] do
    end

    collection do
      get :logout
      get :personal_edit
    end
  end

  resources :categories, only: :index do
    member do
      get :parent
      get :child
      get :grandchild
    end
  end

  resources :brands, only: :index
end