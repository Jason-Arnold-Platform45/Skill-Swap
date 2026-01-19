Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations]


  # Auth endpoints
  resource  :session, only: [:create, :destroy]
  resources :users,   only: [:create] do
    collection do
      get :me
    end
  end

  # Core resources
  resources :skills,  only: [:index, :show, :create, :update, :destroy]
  resources :matches, only: [:index, :create, :update, :destroy]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
