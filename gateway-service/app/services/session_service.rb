class SessionService
  SESSION_SERVICE_URL = Rails.configuration.session_service_url
  private_constant :SESSION_SERVICE_URL

  def get_user_info(token, user_uid)
    response = RestClient.get "#{SESSION_SERVICE_URL}/users/#{user_uid}", { accept: :json, Authorization: "Bearer #{token}" }
    JSON.parse(response.body)
  end
end
