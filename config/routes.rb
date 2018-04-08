Rails.application.routes.draw do
  devise_for :user
  namespace :admin do
    resources :conferences
    resources :topics
    root to: "conferences#index"
  end

  namespace :api do
    resources :conferences, only: :create
    get '/webhooks/sync', to: 'webhooks#sync'
  end
end
