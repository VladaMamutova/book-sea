Rails.application.routes.draw do
  resources :libraries
  resources :taken_books

  post 'library_books/:library_uid/book/:book_uid', to: 'library_books#add_book'
  delete 'library_books/:library_uid/book/:book_uid', to: 'library_books#remove_book'

  post 'taken_books/:library_uid/book/:book_uid/take', to: 'taken_books#take_book'
  post 'taken_books/:library_uid/book/:book_uid/return', to: 'taken_books#return_book'
end
