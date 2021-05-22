class LibraryService
  LIBRARY_SERVICE_URL = Rails.configuration.library_service_url
  private_constant :LIBRARY_SERVICE_URL

  def get_library_books(library_uid)
    response = RestClient.get "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/books"
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    # Специфические ошибки запроса будут обработаны в ErrorHandler,
    # в общих случаях кидаем LibraryProcessError.
    raise Error::LibraryProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def add_book_to_library(book_uid, library_uid, available_count)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}"
    params = { available_count: available_count }
    response = RestClient.post url, params, { content_type: :json, accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    # Специфические ошибки запроса будут обработаны в ErrorHandler,
    # в общих случаях кидаем LibraryProcessError.
    raise Error::LibraryProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def remove_book_from_library(book_uid, library_uid)
    RestClient.delete "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}"
  rescue RestClient::ExceptionWithResponse => e
    # Специфические ошибки запроса будут обработаны в ErrorHandler,
    # в общих случаях кидаем LibraryProcessError.
    raise Error::LibraryProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def take_book_from_library(book_uid, library_uid)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}/take"
    response = RestClient.post url, {}, { accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    # Специфические ошибки запроса будут обработаны в ErrorHandler,
    # в общих случаях кидаем LibraryProcessError.
    raise Error::BookNotAvailable, extract_message(e.response) if e.response.code == 409
    raise Error::LibraryProcessError, extract_message(e.response) if e.response.code != 404

    raise e
  end

  def return_book_to_library(book_uid, library_uid, status)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}/return"
    params = { status: status }
    response = RestClient.post url, params, { content_type: :json, accept: :json }
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    # Специфические ошибки запроса будут обработаны в ErrorHandler,
    # в общих случаях кидаем LibraryProcessError.
    raise Error::LibraryProcessError, extract_message(e.response) if [400, 404].exclude? e.response.code

    raise e
  end

  private

  def extract_message(response)
    JSON.parse(response.body)['message']
  end
end
