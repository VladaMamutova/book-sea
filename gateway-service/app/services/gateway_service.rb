class GatewayService
  GATEWAY_ID = 1
  GATEWAY_SECRET = Rails.application.secret_key_base
  private_constant :GATEWAY_ID
  private_constant :GATEWAY_SECRET

  def get_books(params)
    Rails.logger.info 'Request to Books Service to get books'
    BookService.new.get_books(params)

  # Отлавливаем ошибки микросервисной авторизации (RestClient::Unauthorized)
  # и истечение срока действия токена (RestClient::Forbidden).
  rescue RestClient::Unauthorized, RestClient::Forbidden
    # запрашиваем новый токен
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    # повторяем запрос
    Rails.logger.info 'Request to Books Service to get books again'
    BookService.new.get_books(params)
  end

  def get_book_info(book_uid)
    Rails.logger.info "Request to Books Service to get book '#{book_uid}'"
    BookService.new.get_book_info(book_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to get book '#{book_uid}' again"
    BookService.new.get_book_info(book_uid)
  end

  def get_author_info(author_uid)
    Rails.logger.info "Request to Books Service to get author '#{author_uid}'"
    BookService.new.get_author_info(author_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to get author '#{author_uid}' again"
    BookService.new.get_author_info(author_uid)
  end

  def get_author_with_books(author_uid)
    Rails.logger.info "Request to Books Service to get author '#{author_uid}' with books"
    BookService.new.get_author_with_books(author_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to get author '#{author_uid}' with books again"
    BookService.new.get_author_with_books(author_uid)
  end

  def add_book(book_params)
    Rails.logger.info "Request to Books Service to add book (#{params_to_string(book_params)})"
    BookService.new.add_book(book_params)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to add book (#{params_to_string(book_params)}) again"
    BookService.new.add_book(book_params)
  end

  def remove_book(book_uid)
    Rails.logger.info "Request to Books Service to remove book '#{book_uid}'"
    BookService.new.remove_book(book_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to remove book '#{book_uid}'"
    BookService.new.remove_book(book_uid)
  end

  def add_book_to_library(book_uid, library_uid, number)
    raise Error::RecordInvalid.new('Validation failed', ['number must be greater than 0']) if number <= 0

    begin
      Rails.logger.info "Request to Books Service to add book '#{book_uid}' (number: #{number}) to library #{library_uid}"
      BookService.new.add_book_to_library(book_uid, library_uid)
    rescue RestClient::Unauthorized, RestClient::Forbidden
      Rails.logger.info 'Request to Book Service for a token'
      BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

      Rails.logger.info "Request to Books Service to add book '#{book_uid}' (number: #{number}) to library '#{library_uid}'"
      BookService.new.add_book_to_library(book_uid, library_uid)
    end

    LibraryService.new.add_book_to_library(book_uid, library_uid, number)
  end

  def remove_book_from_library(book_uid, library_uid)
    LibraryService.new.remove_book_from_library(book_uid, library_uid)

    begin
      Rails.logger.info "Request to Books Service to remove book '#{book_uid}' from library '#{library_uid}'"
      BookService.new.remove_book_from_library(book_uid, library_uid)
    rescue RestClient::Unauthorized, RestClient::Forbidden
      Rails.logger.info 'Request to Book Service for a token'
      BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

      Rails.logger.info "Request to Books Service to remove book '#{book_uid}' from library '#{library_uid}'"
      BookService.new.remove_book_from_library(book_uid, library_uid)
    end
  end

  def get_library_books(library_uid)
    library_books = LibraryService.new.get_library_books(library_uid)
    books = []
    library_books.each do |library_book|
      book_uid = library_book['book_uid']
      available_count = library_book['available_count']

      begin
        book = get_book_info(book_uid)
        book['available_count'] = available_count
        books << book
      rescue RestClient::ExceptionWithResponse => e
        Rails.logger.info "Error: #{extract_message(e.response)}"
      end
    end

    books
  end

  def find_book_in_libraries(book_uid)
    libraries = []

    begin
      library_uids = get_book_libraries(book_uid)

      library_uids.each do |library_uid|
        begin
          libraries << LibraryService.new.get_library_book_info(library_uid, book_uid)
        rescue RestClient::ExceptionWithResponse => e
          Rails.logger.info "Error: #{extract_message(e.response)}"
        end
      end
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.info "Error: #{extract_message(e.response)}"
    end

    libraries
  end

  private

  def get_book_libraries(book_uid)
    Rails.logger.info "Request to Books Service to get libraries for book '#{book_uid}'"
    BookService.new.get_book_libraries(book_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to get libraries for book '#{book_uid}'"
    BookService.new.get_book_libraries(book_uid)
  end

  def params_to_string(params)
    hash = params.to_h
    hash.map { |key, value| "#{key.gsub('_', ' ')}: '#{value}'" }.join(', ')
  end

  def extract_message(response)
    JSON.parse(response.body)['message']
  end
end
