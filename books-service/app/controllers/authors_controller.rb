class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show]

  # prevent CSRF attacks, use :null_session for APIs
  protect_from_forgery with: :null_session

  def show
    render json: @author, serializer: AuthorSerializer
  end

  private

  def set_author
    @author = Author.find_by(author_uid: params[:id]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Author '#{params[:id]}' not found" unless @author
  end
end
