class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {}, role = nil)
    @headers = headers
    @role = role
  end

  def call
    user
  end

  private

  attr_reader :headers, :role

  def user
    @user = User.find_by(user_uid: @decoded_auth_token[:user_uid]) if decoded_auth_token
    if @user
      errors.add(:message, 'Invalid role') if @user.role != @decoded_auth_token[:role]
      errors.add(:message, 'You do not have permission to perform this action') if @role && @role != @user.role

      errors.empty? ? @user : nil
    else
      errors.add(:message, 'Invalid token') && nil
    end
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
