Rails.application.routes.draw do
  get '/_health', to: 'application#health'

  resources :libraries

  get '/libraries/:library_uid/books', to: 'library_books#show_library_books'
  get '/libraries/:library_uid/books/:book_uid', to: 'library_books#show_library_book_info'

  post '/libraries/:library_uid/book/:book_uid', to: 'library_books#add_book'
  delete '/libraries/:library_uid/book/:book_uid', to: 'library_books#remove_book'

  post '/libraries/:library_uid/book/:book_uid/take', to: 'taken_books#take_book'
  post '/libraries/:library_uid/book/:book_uid/return', to: 'taken_books#return_book'

  get '/taken_books/user/:user_uid', to: 'taken_books#show_user_taken_books'
  delete "/taken_books/:taken_book_uid", to: 'taken_books#destroy'
end
