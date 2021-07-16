class SessionService
  SESSION_SERVICE_URL = Rails.configuration.session_service_url
  private_constant :SESSION_SERVICE_URL

  def get_user_info(token, user_uid)
    response = RestClient.get "#{SESSION_SERVICE_URL}/users/#{user_uid}", { accept: :json, Authorization: "Bearer #{token}" }
    JSON.parse(response.body)
  end

  def get_users_info(token)
    response = RestClient.get "#{SESSION_SERVICE_URL}/users", { accept: :json, Authorization: "Bearer #{token}" }
    JSON.parse(response.body)
  end

  def register(token, login, password)
    url = "#{SESSION_SERVICE_URL}/users"
    params = { login: login, password: password, role: 'user' }.to_json
    headers = { content_type: :json, accept: :json, Authorization: "Bearer #{token}" }
    response = RestClient.post url, params, headers
    JSON.parse(response.body)
  end

  def delete_account(token, user_uid)
    RestClient.delete "#{SESSION_SERVICE_URL}/users/#{user_uid}", { Authorization: "Bearer #{token}" }
  end
end
