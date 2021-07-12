class BookService
  BOOKS_SERVICE_URL = Rails.configuration.books_service_url
  private_constant :BOOKS_SERVICE_URL

  @@token = '' # class variable, shared between all instances

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
end
