Rails.application.routes.draw do
  devise_for :users

  get "/me", to: "users#me"

  resources :skills, only: [:index, :show, :create, :update, :destroy]
  resources :matches, only: [:index, :create, :update, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
