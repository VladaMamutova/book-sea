class LibraryService
  LIBRARY_SERVICE_URL = Rails.configuration.library_service_url
  private_constant :LIBRARY_SERVICE_URL

  def add_book_to_library(book_uid, library_uid, available_count)
    url = "#{LIBRARY_SERVICE_URL}/library_books/#{library_uid}/book/#{book_uid}"
    params = { available_count: available_count }
    response = RestClient.post url, params, { content_type: :json, accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    # Специфические ошибки запроса будут обработаны в ErrorHandler,
    # в общих случаях кидаем BooksProcessError.
    raise Error::BooksProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def remove_book_from_library(book_uid, library_uid)
    RestClient.delete "#{LIBRARY_SERVICE_URL}/library_books/#{library_uid}/book/#{book_uid}"
  rescue RestClient::ExceptionWithResponse => e
    # Специфические ошибки запроса будут обработаны в ErrorHandler,
    # в общих случаях кидаем BooksProcessError.
    raise Error::BooksProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  private

  def extract_message(response)
    JSON.parse(response.body)['message']
  end
end
