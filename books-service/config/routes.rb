Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/_health', to: 'application#health'

  resources :books
  resources :genres
  resources :authors do
    resources :books
  end

  get '/books/:id/libraries', to: 'books#show_book_libraries'
  post '/books/:id/library/:library_uid', to: 'books#add_book_to_library'
  delete '/books/:id/library/:library_uid', to: 'books#remove_book_from_library'

  get '/auth', to: 'authorization#authorize'
end
