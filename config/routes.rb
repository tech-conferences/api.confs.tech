Rails.application.routes.draw do
  get 'github/index'
  get 'github/list'

  root 'github#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'authenticate', to: 'authentication#authenticate'

  get '/webhooks/sync', to: 'webhooks#sync'
end
