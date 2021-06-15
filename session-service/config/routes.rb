Rails.application.routes.draw do
  get '/_health', to: 'application#health'

  resources :users

  post '/auth', to: 'authentication#authenticate'
  post '/verify', to: 'authentication#verify'
end
