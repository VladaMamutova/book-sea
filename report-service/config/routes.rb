Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/_health', to: 'application#health'

  get '/books-return', to: 'books_return#index'
  get '/books-genre', to: 'books_genre#index'
end
