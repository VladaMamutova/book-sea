class GatewayService
  GATEWAY_ID = 1
  GATEWAY_SECRET = Rails.application.secret_key_base
  private_constant :GATEWAY_ID
  private_constant :GATEWAY_SECRET

  def get_books(params)
    Rails.logger.info 'Request to get books'
    BookService.new.get_books(params)

  rescue RestClient::Unauthorized # ошибки микросервисной авторизации
    Rails.logger.info "Request for a token to Book Service: (#{GATEWAY_ID}:#{GATEWAY_SECRET})"
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info 'Request to get books again'
    BookService.new.get_books(params)

  rescue RestClient::Forbidden # истёк срок действия токена
    # запрашиваем новый токен
    Rails.logger.info "Request for a token to Book Service: (#{GATEWAY_ID}:#{GATEWAY_SECRET})"
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    # повторяем запрос
    Rails.logger.info 'Request to get books again'
    BookService.new.get_books(params)

  rescue RestClient::ExceptionWithResponse => e
    raise Error::BookProcessError, extract_message(e.response)
  end

  def add_book_to_library(book_uid, library_uid, available_count)
    if available_count <= 0
      raise Error::RecordInvalid.new('Validation failed', ['available_count must be greater than 0'])
    end

    BookService.new.add_book_to_library(book_uid, library_uid)
    LibraryService.new.add_book_to_library(book_uid, library_uid, available_count)
  end

  def remove_book_from_library(book_uid, library_uid)
    LibraryService.new.remove_book_from_library(book_uid, library_uid)
    BookService.new.remove_book_from_library(book_uid, library_uid)
  end

  def get_library_books(library_uid)
    library_books = LibraryService.new.get_library_books(library_uid)
    books = []
    library_books.each do |library_book|
      book_uid = library_book['book_uid']
      available_count = library_book['available_count']

      book = BookService.new.get_book_info(book_uid)
      book['available_count'] = available_count
      books << book
    end

    books
  end

  def find_book_in_libraries(book_uid)
    library_uids = BookService.new.get_book_libraries(book_uid)
    libraries = []
    library_uids.each do |library_uid|
      libraries << LibraryService.new.get_library_book_info(library_uid, book_uid)
    end

    libraries
  end

  private

  def extract_message(response)
    JSON.parse(response.body)['message']
  end
end
