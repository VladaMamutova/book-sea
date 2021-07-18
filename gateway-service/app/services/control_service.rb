class ControlService
  CONTROL_SERVICE_URL = Rails.configuration.control_service_url
  private_constant :CONTROL_SERVICE_URL

  def get_user_info(user_uid)
    response = RestClient.get "#{CONTROL_SERVICE_URL}/control/user/#{user_uid}"
    JSON.parse(response.body)
  end

  def add_taken_book(user_uid, taken_book_uid)
    url = "#{CONTROL_SERVICE_URL}/control/user/#{user_uid}/taken_books"
    headers = { content_type: :json, accept: :json }
    params = { taken_book_uid: taken_book_uid }.to_json
    RestClient.post url, params, headers
  end

  def remove_taken_book(user_uid, taken_book_uid)
    RestClient.delete "#{CONTROL_SERVICE_URL}/control/user/#{user_uid}/taken_books/#{taken_book_uid}"
  end

  def update_limit(user_uid, limit)
    url = "#{CONTROL_SERVICE_URL}/control/user/#{user_uid}"
    headers = { content_type: :json }
    params = { limit: limit }.to_json
    RestClient.patch url, params, headers
  end

  def show_taken_books(user_uid)
    response = RestClient.get "#{CONTROL_SERVICE_URL}/control/user/#{user_uid}/taken_books"
    JSON.parse(response.body)
  end

  def start_monitoring(user_uid, limit)
    url = "#{CONTROL_SERVICE_URL}/control/user/#{user_uid}"
    headers = { content_type: :json }
    params = { limit: limit }.to_json
    RestClient.post url, params, headers
  end
end
