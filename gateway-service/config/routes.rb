Rails.application.routes.draw do
  get 'books/:book_uid', to: 'gateway#show_book_info'
  get 'books', to: 'gateway#show_books'
  get 'author/:author_uid', to: 'gateway#show_author_info'
  get 'author/:author_uid/books', to: 'gateway#show_author_with_books'
  post 'books', to: 'gateway#add_book'
  delete 'books/:book_uid', to: 'gateway#remove_book'

  post '/library/:library_uid/book/:book_uid', to: 'gateway#add_book_to_library'
  delete '/library/:library_uid/book/:book_uid', to: 'gateway#remove_book_from_library'

  # GET /library/{libraryUid}/books
  # POST /library/{libraryUid}/book/{bookUid}/take
  # POST /library/{libraryUid}/book/{bookUid}/return
end
