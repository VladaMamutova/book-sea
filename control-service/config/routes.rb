Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/_health', to: 'application#health'

  get '/control/user/:user_uid', to: 'user_monitoring#show'
  get '/control/user/:user_uid/taken_books', to: 'user_monitoring#get_taken_books'
  post '/control/user/:user_uid/taken_books', to: 'user_monitoring#add_taken_book'
  delete '/control/user/:user_uid/taken_books/:taken_book_uid', to: 'user_monitoring#remove_taken_book'
  patch '/control/user/:user_uid', to: 'user_monitoring#update_limit'
  post '/control/user/:user_uid', to: 'user_monitoring#start_user_monitoring'
end
