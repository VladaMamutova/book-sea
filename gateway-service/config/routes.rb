Rails.application.routes.draw do
  get 'books/:book_uid', to: 'gateway#show_book_info'
  get 'books', to: 'gateway#show_books'
  get 'author/:author_uid', to: 'gateway#show_author_info'
  get 'author/:author_uid/books', to: 'gateway#show_author_with_books'
  post 'books', to: 'gateway#add_book'
  delete 'books/:book_uid', to: 'gateway#remove_book'
end
