class TokenGenerator
  prepend SimpleCommand

  def initialize(client_id, client_secret)
    @client_id = client_id
    @client_secret = client_secret
  end

  def call
    JsonWebToken.encode({ client_id: @client_id, client_secret: @client_secret })
  end

  private

  attr_accessor :client_id, :client_secret
end
