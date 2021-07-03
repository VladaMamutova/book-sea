Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/_health', to: 'application#health'

  get '/rating/user/:user_uid', to: 'ratings#show'
  post '/rating/user', to: 'ratings#create'
end
