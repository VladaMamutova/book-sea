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
    params = { number: number }.to_json
    response = RestClient.post url, params, { content_type: :json, accept: :json }
    JSON.parse(response.body)
  end

  def remove_book_from_library(book_uid, library_uid)
    RestClient.delete "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}"
  end

  def take_book(user_uid, book_uid, library_uid)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}/take"
    params = { user_uid: user_uid }.to_json
    response = RestClient.post url, params, { content_type: :json, accept: :json }
    JSON.parse(response.body)
  end

  def return_book(user_uid, book_uid, library_uid, status)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/book/#{book_uid}/return"
    params = { user_uid: user_uid, status: status }.to_json
    RestClient.post url, params, { content_type: :json, accept: :json }
  end

  def get_library_book_info(library_uid, book_uid)
    url = "#{LIBRARY_SERVICE_URL}/libraries/#{library_uid}/books/#{book_uid}"
    response = RestClient.get url, { accept: :json }
    JSON.parse(response.body)
  end

  def remove_taken_book(taken_book_uid)
    RestClient.delete "#{LIBRARY_SERVICE_URL}/taken_books/#{taken_book_uid}"
  end
end
