Rails.application.routes.draw do
  resources :libraries
  resources :taken_books

  get '/libraries/:library_uid/books', to: 'library_books#show_library_books'

  post '/libraries/:library_uid/book/:book_uid', to: 'library_books#add_book'
  delete '/libraries/:library_uid/book/:book_uid', to: 'library_books#remove_book'

  post '/libraries/:library_uid/book/:book_uid/take', to: 'taken_books#take_book'
  post '/libraries/:library_uid/book/:book_uid/return', to: 'taken_books#return_book'
end
