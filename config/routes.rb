require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :user

  root to: "admin/conferences#index"

  namespace :admin do
    resources :conferences
    resources :topics
    root to: "conferences#index"

    authenticate :user do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  namespace :api do
    resources :conferences, only: :create
    get '/webhooks/sync', to: 'webhooks#sync'
  end
end
