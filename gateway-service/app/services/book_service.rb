class BookService
  BOOKS_SERVICE_URL = Rails.configuration.books_service_url
  private_constant :BOOKS_SERVICE_URL

  @@token = '' # class variable, shared between all instances

  # Ошибки микросервисной авторизации будут обработаны в GatewayService,
  # специфические для ошибки запроса будут обработаны в ErrorHandler.

  def request_token(client_id, client_secret)
    resource = RestClient::Resource.new("#{BOOKS_SERVICE_URL}/auth", user: client_id, password: client_secret)
    response = resource.get
    @@token = JSON.parse(response.body)['token']
  end

  def get_book_info(book_uid)
    url = "#{BOOKS_SERVICE_URL}/books/#{book_uid}"
    headers = { accept: :json, Authorization: "Bearer #{@@token}" }
    response = RestClient.get url, headers
    JSON.parse(response.body)
  end

  def get_books(params)
    safe_params = params.permit(:name, :author, :genre, :page, :per_page)
    url = "#{BOOKS_SERVICE_URL}/books?#{safe_params.to_query}"
    headers = { accept: :json, Authorization: "Bearer #{@@token}" }
    response = RestClient.get url, headers
    JSON.parse(response.body)
  end

  def get_authors
    url = "#{BOOKS_SERVICE_URL}/authors"
    headers = { accept: :json, Authorization: "Bearer #{@@token}" }
    response = RestClient.get url, headers
    JSON.parse(response.body)
  end

  def get_genres
    url = "#{BOOKS_SERVICE_URL}/genres"
    headers = { accept: :json, Authorization: "Bearer #{@@token}" }
    response = RestClient.get url, headers
    JSON.parse(response.body)
  end

  def get_author_info(author_uid)
    url = "#{BOOKS_SERVICE_URL}/authors/#{author_uid}"
    headers = { accept: :json, Authorization: "Bearer #{@@token}" }
    response = RestClient.get url, headers
    JSON.parse(response.body)
  end

  def get_author_with_books(author_uid)
    url = "#{BOOKS_SERVICE_URL}/authors/#{author_uid}/books"
    headers = { accept: :json, Authorization: "Bearer #{@@token}" }
    response = RestClient.get url, headers
    JSON.parse(response.body)
  end

  def add_book(book_params)
    url = "#{BOOKS_SERVICE_URL}/books"
    params = { book: { name: book_params[:name] }, author: book_params[:author].as_json, genre: book_params[:genre] }
    headers = { content_type: :json, accept: :json, Authorization: "Bearer #{@@token}" }
    response = RestClient.post url, params, headers
    JSON.parse(response.body)
  end

  def remove_book(book_uid)
    RestClient.delete "#{BOOKS_SERVICE_URL}/books/#{book_uid}", { Authorization: "Bearer #{@@token}" }
  end

  def add_book_to_library(book_uid, library_uid)
    RestClient.post "#{BOOKS_SERVICE_URL}/books/#{book_uid}/library/#{library_uid}", {}, { Authorization: "Bearer #{@@token}" }
  end

  def remove_book_from_library(book_uid, library_uid)
    RestClient.delete "#{BOOKS_SERVICE_URL}/books/#{book_uid}/library/#{library_uid}", { Authorization: "Bearer #{@@token}" }
  end

  def get_book_libraries(book_uid)
    response = RestClient.get "#{BOOKS_SERVICE_URL}/books/#{book_uid}/libraries", { accept: :json, Authorization: "Bearer #{@@token}" }
    JSON.parse(response.body)
  end
end
