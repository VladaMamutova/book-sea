Rails.application.routes.draw do
  resources :users

  post 'auth', to: 'authentication#authenticate'
  post 'verify', to: 'authentication#verify'
end
