class AuthorizationController < ApplicationController
  def authorize
    client_id, client_secret = login_and_password_from_header
    command = TokenGenerator.call(client_id, client_secret)

    if command.success?
      render json: { token: command.result }
    else
      render json: command.errors, status: :forbidden
    end
  end

  private

  def login_and_password_from_header
    # { Authorization: Basic <client_id>:<client_secret> }
    ActionController::HttpAuthentication::Basic.user_name_and_password(request)
  end
end
