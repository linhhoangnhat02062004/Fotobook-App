Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Devise routes for authentication
  devise_for :users, controllers: {
    registrations: 'devise/registrations'
  }

  # Root path - redirect to admin dashboard if admin, feeds if regular user, otherwise to login
  root 'feeds#index'

  # Main application routes
  get 'feeds', to: 'feeds#index', as: :feeds
  get 'discover', to: 'feeds#discover', as: :discover
  get '/discovery', to: 'feeds#discovery', as: :discovery
  get '/search', to: 'feeds#search', as: :search
  
  # User profile routes
  get 'profile', to: 'users#show', as: :profile, defaults: { id: 'current' }
  get 'profile/edit', to: 'users#edit', as: :edit_profile
  patch 'profile', to: 'users#update', as: :update_profile
  
  # User management (for viewing other users) - thêm constraints để tránh conflict với Devise
  resources :users, only: [:show], constraints: lambda { |req| 
    !req.path.match?(/\/(sign_in|sign_out|sign_up|password|confirmation|unlock)/)
  } do
    member do
      post 'follow', to: 'users#follow', as: :follow
      delete 'unfollow', to: 'users#unfollow', as: :unfollow
    end
  end

  # Photos routes
  resources :photos do
    member do
      post 'like', to: 'photos#like', as: :like
      delete 'unlike', to: 'photos#unlike', as: :unlike
    end
  end

  # Albums routes
  resources :albums do
    member do
      post 'like', to: 'albums#like', as: :like
      delete 'unlike', to: 'albums#unlike', as: :unlike
    end
  end

  # Admin routes
  get 'admin/dashboard', to: 'admin#dashboard', as: :admin_dashboard
  get 'admin/users', to: 'admin#users', as: :admin_users
  get 'admin/users/:id', to: 'admin#show_user', as: :admin_user
  get 'admin/users/:id/edit', to: 'admin#edit_user', as: :edit_admin_user
  patch 'admin/users/:id', to: 'admin#update_user', as: :admin_update_user
  delete 'admin/users/:id', to: 'admin#destroy_user', as: :admin_destroy_user
  
  get 'admin/albums', to: 'admin#albums', as: :admin_albums
  get 'admin/albums/:id', to: 'admin#show_album', as: :admin_album
  patch 'admin/albums/:id', to: 'admin#update_album', as: :admin_update_album
  delete 'admin/albums/:id', to: 'admin#destroy_album', as: :admin_destroy_album
  
  get 'admin/photos', to: 'admin#photos', as: :admin_photos
  get 'admin/photos/:id', to: 'admin#show_photo', as: :admin_photo
  patch 'admin/photos/:id', to: 'admin#update_photo', as: :admin_update_photo
  delete 'admin/photos/:id', to: 'admin#destroy_photo', as: :admin_destroy_photo

  # PWA routes
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # API routes (for future use)
  namespace :api do
    namespace :v1 do
      resources :photos, only: [:index, :show]
      resources :albums, only: [:index, :show]
      resources :users, only: [:show]
    end
  end

  # Follow/Unfollow routes
  post '/users/:id/follow', to: 'users#follow'
  delete '/users/:id/unfollow', to: 'users#unfollow'
  get '/users/:id/followers', to: 'users#followers', as: :user_followers
  get '/users/:id/followings', to: 'users#followings', as: :user_followings
end
