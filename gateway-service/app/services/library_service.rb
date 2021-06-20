class LibraryService
  LIBRARY_SERVICE_URL = Rails.configuration.library_service_url
  private_constant :LIBRARY_SERVICE_URL

  # Специфические ошибки запроса будут обработаны в ErrorHandler,
  # в общих случаях кидаем LibraryProcessError.

  def show_libraries
    response = RestClient.get "#{LIBRARY_SERVICE_URL}/libraries"
    JSON.parse(response.body)
  end

  def get_library_books(library_uid)
    response = RestClient.get "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/books"
    JSON.parse(response.body)
  end

  def add_book_to_library(book_uid, library_uid, number)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}"
    params = { number: number }
    response = RestClient.post url, params, { content_type: :json, accept: :json }
    JSON.parse(response.body)
  end

  def remove_book_from_library(book_uid, library_uid)
    RestClient.delete "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}"
  end

  def take_book_from_library(book_uid, library_uid)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}/take"
    response = RestClient.post url, {}, { accept: :json }
    JSON.parse(response.body)
  end

  def return_book_to_library(book_uid, library_uid, status)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}/return"
    params = { status: status }
    RestClient.post url, params, { content_type: :json, accept: :json }
  end

  def get_library_book_info(library_uid, book_uid)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/books/#{book_uid}"
    response = RestClient.get url, { accept: :json }
    JSON.parse(response.body)
  end
end
