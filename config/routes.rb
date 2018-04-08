Rails.application.routes.draw do
  devise_for :user
  namespace :admin do
    resources :conferences
    resources :topics
    root to: "conferences#index"
  end

  scope :api do
    resources :conferences, only: :create
    get '/webhooks/sync', to: 'api/webhooks#sync'
  end
end
