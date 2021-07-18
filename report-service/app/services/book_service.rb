class BookService
  BOOKS_SERVICE_URL = Rails.configuration.books_service_url
  REPORT_ID = 2
  REPORT_SECRET = Rails.application.secret_key_base
  private_constant :REPORT_ID
  private_constant :REPORT_SECRET

  private_constant :BOOKS_SERVICE_URL

  @@token = '' # class variable, shared between all instances

  def get_book_info(book_uid, logger)
    logger.info "Request to Books Service to get book '#{book_uid}'"
    request_for_book_info(book_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    logger.info 'Request to Book Service for a token'
    request_token

    logger.info "Request to Books Service to get book '#{book_uid}' again"
    request_for_book_info(book_uid)
  end

  private

  def request_token
    resource = RestClient::Resource.new("#{BOOKS_SERVICE_URL}/auth", user: REPORT_ID, password: REPORT_SECRET)
    response = resource.get
    @@token = JSON.parse(response.body)['token']
  end

  def request_for_book_info(book_uid)
    url = "#{BOOKS_SERVICE_URL}/books/#{book_uid}"
    headers = { accept: :json, Authorization: "Bearer #{@@token}" }
    response = RestClient.get url, headers
    JSON.parse(response.body)
  end
end
