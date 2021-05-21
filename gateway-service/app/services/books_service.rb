class BooksService
  BOOKS_SERVICE_URL = Rails.configuration.books_service_url
  private_constant :BOOKS_SERVICE_URL

  def get_book_info(book_uid)
    response = RestClient.get "#{BOOKS_SERVICE_URL}/books/#{book_uid}", { accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    # Ошибка 404 будет обработана ErrorHandler, во всех остальных случаях кидаем BooksProcessError.
    raise Error::BooksProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def get_books(params)
    page = params[:page].to_i
    per_page = params[:per_page] ? params[:per_page].to_i : 20

    response = RestClient.get "#{BOOKS_SERVICE_URL}/books?page=#{page}&per_page=#{per_page}", { accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    raise Error::BooksProcessError, extract_message(e.response)
  end

  def get_author_info(author_uid)
    response = RestClient.get "#{BOOKS_SERVICE_URL}/authors/#{author_uid}", { accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    # Ошибка 404 будет обработана ErrorHandler, во всех остальных случаях кидаем BooksProcessError.
    raise Error::BooksProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def get_author_with_books(author_uid)
    response = RestClient.get "#{BOOKS_SERVICE_URL}/authors/#{author_uid}/books", { accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    # Ошибка 404 будет обработана ErrorHandler, во всех остальных случаях кидаем BooksProcessError.
    raise Error::BooksProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def add_book(book_params)
    params = { book: { name: book_params[:name] }, author: book_params[:author].as_json, genre: book_params[:genre] }
    response = RestClient.post "#{BOOKS_SERVICE_URL}/books", params, { content_type: :json, accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    # Специфические ошибки запроса будут обработаны в ErrorHandler,
    # в общих случаях кидаем BooksProcessError.
    raise Error::BooksProcessError, extract_message(e.response) if [400, 404].exclude? e.response.code

    raise e
  end

  def remove_book(book_uid)
    RestClient.delete "#{BOOKS_SERVICE_URL}/books/#{book_uid}"
  rescue RestClient::ExceptionWithResponse => e
    # Ошибка 404 будет обработана ErrorHandler, во всех остальных случаях кидаем BooksProcessError.
    raise Error::BooksProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  private

  def extract_message(response)
    JSON.parse(response.body)['message']
  end
end
