class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find_by(user_uid: decoded_auth_token[:user_uid]) if decoded_auth_token
    @user || errors.add(:message, 'Invalid token') && nil
  end

  def decoded_auth_token
    @decoded_auth_token = JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    return headers['Authorization'].split(' ').last if headers['Authorization'].present?

    errors.add(:message, 'Missing token')
    nil
  end
end
