# Singleton class
class JsonWebToken
  class << self
    def decode(token)
      # Expiration time is automatically verified in JWT.decode().
      # raises JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature
      body = JWT.decode(token, ENV['SESSION_SECRET_KEY'], true, algorithm: 'HS256')[0] # [ { <payload hash> }, {"alg"=>"HS256"} ]
      HashWithIndifferentAccess.new body
    end
  end
end
