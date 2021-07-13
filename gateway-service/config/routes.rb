Rails.application.routes.draw do
  get '/_health', to: 'application#health'

  get '/books', to: 'gateway#show_books'
  get '/books/:book_uid', to: 'gateway#show_book_info'
  post '/books', to: 'gateway#add_book'
  delete '/books/:book_uid', to: 'gateway#remove_book'
  get '/author/:author_uid', to: 'gateway#show_author_info'
  get '/author/:author_uid/books', to: 'gateway#show_author_with_books'
  get '/authors', to: 'gateway#show_authors'
  get '/genres', to: 'gateway#show_genres'

  get '/library', to: 'gateway#show_libraries'
  get '/library/user/books', to: 'gateway#show_taken_books'
  get '/library/:library_uid/books', to: 'gateway#show_library_books'
  get '/library/book/:book_uid', to: 'gateway#find_book_in_libraries'
  post '/library/:library_uid/book/:book_uid', to: 'gateway#add_book_to_library'
  delete '/library/:library_uid/book/:book_uid', to: 'gateway#remove_book_from_library'
  post '/library/:library_uid/book/:book_uid/take', to: 'gateway#take_book'
  post '/library/:library_uid/book/:book_uid/return', to: 'gateway#return_book'

  get '/rating/user', to: 'gateway#show_user_rating' 

  get '/reports/books-genre', to: 'gateway#show_books_genre_report'
  get '/reports/books_return', to: 'gateway#show_books_return_report'
end
