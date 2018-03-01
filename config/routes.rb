Rails.application.routes.draw do
  resources :conferences, only: :create

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'authenticate', to: 'authentication#authenticate'

  get '/webhooks/sync', to: 'webhooks#sync'
end
