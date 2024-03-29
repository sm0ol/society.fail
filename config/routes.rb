Rails.application.routes.draw do
  mount GoodJob::Engine => "jobs"

  resources :users
  resources :posts
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # This line allows for root usernames like /:username
  get '/:username', to: 'users#show', as: :user_profile

  # Defines the root path route ("/")
  root "pages#index"
end
