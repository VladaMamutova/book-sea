Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/_health', to: 'application#health'

  get '/reports/books-return', to: 'reports#books_return'
  get '/reports/books-genre', to: 'reports#books_genre'
end
