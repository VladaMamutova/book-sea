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
    errors.add(:message, 'Invalid token') if !decoded_auth_token || !@decoded_auth_token[:user_uid]

    if @role && @role != @decoded_auth_token[:role]
      errors.add(:message, 'You do not have permission to perform this action')
    end
    
    errors.empty? ? @decoded_auth_token[:user_uid] : nil
  end

  def decoded_auth_token
    @decoded_auth_token = JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    pattern = /^Bearer /
    header = headers['Authorization']
    return header.gsub(pattern, '') if header && header.match(pattern)

    errors.add(:message, 'Missing token')
    nil
  end
end
