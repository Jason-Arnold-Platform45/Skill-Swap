Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations]


  # Auth endpoints
  post   "/signup", to: "auth#signup"
  post   "/login",  to: "auth#login"
  delete "/logout", to: "auth#logout"

  # Current authenticated user
  get "/me", to: "users#me"

  # Core resources
  resources :skills,  only: [:index, :show, :create, :update, :destroy]
  resources :matches, only: [:index, :create, :update, :destroy]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
