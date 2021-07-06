class RatingService
  RATING_SERVICE_URL = Rails.configuration.rating_service_url
  private_constant :RATING_SERVICE_URL

  def show_user_rating(user_uid)
    response = RestClient.get "#{RATING_SERVICE_URL}/rating/user/#{user_uid}", { accept: :json }
    JSON.parse(response.body)
  end

  def update_score(user_uid, in_time, status)
    url = "#{RATING_SERVICE_URL}/rating/user/#{user_uid}/update"
    params = { in_time: in_time, status: status }.to_json
    response = RestClient.post url, params, { content_type: :json, accept: :json }
    JSON.parse(response.body)
  end
end
