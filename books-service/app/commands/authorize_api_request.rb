class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    check_client
  end

  private

  attr_reader :headers

  def check_client
    decode_auth_token

    client_id = @decoded_auth_token[:client_id]
    client_secret = @decoded_auth_token[:client_secret]

    if client_id && client_secret
      # TODO: check client_id and client_secret ?
    else
      errors.add(:message, 'Invalid client id and client secret')
    end
  end

  def decode_auth_token
    @decoded_auth_token = JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    return headers['Authorization'].split(' ').last if headers['Authorization'].present?

    errors.add(:message, 'Missing token')
    nil
  end
end
