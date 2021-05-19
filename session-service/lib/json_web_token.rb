# Singleton class
class JsonWebToken
  class << self
    SECRET_KEY = Rails.application.secrets.secret_key_base

    # JWT token = base64(header) + '.' + base64(payload) + '.' + base64(signature)
    # Header consists of the type of the token (JWT)
    # and the type of encryption algorithm (HS256) encoded in base-64.
    # Payload contains information about the user and his or her role (login, password, user_uid)
    # Signature is a unique key that identifies the service which creates the header.
    def encode(payload, exp = 1.minutes.from_now)
      payload[:exp] = exp.to_i
      # The signature of the token will be a base-64 encoded version
      # of the Rails application's secret key.
      # Because each application has a unique base key,
      # this secret key serves as the token signature.
      JWT.encode(payload, SECRET_KEY)
    end

    def decode(token)
      # Expiration time is automatically verified in JWT.decode().
      # raises JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature
      body = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')[0] # [ { <payload hash> }, {"alg"=>"HS256"} ]
      HashWithIndifferentAccess.new body
    end
  end
end
