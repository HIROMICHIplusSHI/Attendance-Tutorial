Rails.application.routes.draw do
    # Root route
    root "static_pages#top"

    # Static pages
    get "top" => "static_pages#top"
    get "static_pages/top"

    # Users
    get '/signup', to: 'users#new'
    get 'users/index'
    get 'users/show'

    # Health check
    get "up" => "rails/health#show", as: :rails_health_check
  end
