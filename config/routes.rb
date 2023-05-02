Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  
  root to: "home#index"
  resources :users do
    resource :relationships, only: [:create, :destroy]
    member do
      get :followings, :followers, :similar_users
    end
  end
  
  resources :posts do
    resources :favorites, only: [:create, :destroy]
  end
  
  resources :favorites, only: [:index]
end
