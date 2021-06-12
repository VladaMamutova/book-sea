class BookService
  BOOKS_SERVICE_URL = Rails.configuration.books_service_url
  private_constant :BOOKS_SERVICE_URL

  @@token = '' # class variable, shared between all instances

  # Ошибки микросервисной авторизации будут обработаны в GatewayService,
  # специфические для ошибки запроса будут обработаны в ErrorHandler,
  # в общих случаях кидаем BookProcessError.

  def request_token(client_id, client_secret)
    resource = RestClient::Resource.new("#{BOOKS_SERVICE_URL}/auth", user: client_id, password: client_secret)
    response = resource.get
    @@token = JSON.parse(response.body)['token']
  end

  def get_book_info(book_uid)
    response = RestClient.get "#{BOOKS_SERVICE_URL}/books/#{book_uid}", { accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    raise Error::BookProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def get_books(params)
    safe_params = params.permit(:name, :author, :genre, :page, :per_page)
    url = "#{BOOKS_SERVICE_URL}/books?#{safe_params.to_query}"
    response = RestClient.get url, { accept: :json, Authorization: "Bearer #{@@token}" }
    JSON.parse(response.body)
  end

  def get_author_info(author_uid)
    response = RestClient.get "#{BOOKS_SERVICE_URL}/authors/#{author_uid}", { accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    raise Error::BookProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def get_author_with_books(author_uid)
    response = RestClient.get "#{BOOKS_SERVICE_URL}/authors/#{author_uid}/books", { accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    raise Error::BookProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def add_book(book_params)
    params = { book: { name: book_params[:name] }, author: book_params[:author].as_json, genre: book_params[:genre] }
    response = RestClient.post "#{BOOKS_SERVICE_URL}/books", params, { content_type: :json, accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    raise Error::BookProcessError, extract_message(e.response) if [400, 404].exclude? e.response.code

    raise e
  end

  def remove_book(book_uid)
    RestClient.delete "#{BOOKS_SERVICE_URL}/books/#{book_uid}"
  rescue RestClient::ExceptionWithResponse => e
    raise Error::BookProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def add_book_to_library(book_uid, library_uid)
    RestClient.post "#{BOOKS_SERVICE_URL}/books/#{book_uid}/#{library_uid}", {}
  rescue RestClient::ExceptionWithResponse => e
    raise Error::BookProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def remove_book_from_library(book_uid, library_uid)
    RestClient.delete "#{BOOKS_SERVICE_URL}/books/#{book_uid}/#{library_uid}"
  rescue RestClient::ExceptionWithResponse => e
    raise Error::BookProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def get_book_libraries(book_uid)
    response = RestClient.get "#{BOOKS_SERVICE_URL}/books/#{book_uid}/libraries", { accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    raise Error::BookProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  private

  def extract_message(response)
    JSON.parse(response.body)['message']
  end
end
