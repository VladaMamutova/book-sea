class GenresController < ApplicationController
  before_action :check_authorization
  
  # prevent CSRF attacks, use :null_session for APIs
  protect_from_forgery with: :null_session

  def index
    @genres = Genre.all
    render json: @genres, each_serializer: GenreSerializer
  end

  def check_authorization
    Rails.logger.info 'Check authorization before API request'
    command = AuthorizeApiRequest.call(request.headers)
    return if command.success?

    raise Error::AuthorizationError, command.errors[:message].first
  end
end
