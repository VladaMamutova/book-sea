class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show]

  # prevent CSRF attacks, use :null_session for APIs
  protect_from_forgery with: :null_session

  def show
    return head :not_found unless @author

    render json: @author, serializer: AuthorSerializer
  end

  private

  def set_author
    @author = Author.find_by(author_uid: params[:id]) # nil if not found
  end
end
