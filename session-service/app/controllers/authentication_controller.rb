class AuthenticationController < ApplicationController
  def authenticate
    login, password = login_and_password_from_header
    command = AuthenticateUser.call(login, password)

    if command.success?
      render json: { token: command.result }
    else
      render json: command.errors, status: :unauthorized
    end
  end

  def verify
    command = AuthorizeApiRequest.call(request.headers)
    if command.success?
      head :ok
    else
      render json: command.errors, status: :unauthorized
    end
  end

  private

  def login_and_password_from_header
    # { Authorization: Basic <login>:<password> }
    ActionController::HttpAuthentication::Basic.user_name_and_password(request)
  end
end
