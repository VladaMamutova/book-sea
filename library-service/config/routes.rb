Rails.application.routes.draw do
  get 'library/:library_uid', to: 'libraries#show'

  post 'library/:library_uid/book/:book_uid', to: 'libraries#add_book'
  delete 'library/:library_uid/book/:book_uid', to: 'libraries#remove_book'

  post 'library/:library_uid/book/:book_uid/take', to: 'libraries#take_book'
  post 'library/:library_uid/book/:book_uid/return', to: 'libraries#return_book'
end
