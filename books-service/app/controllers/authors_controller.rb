class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show update destroy]

  # prevent CSRF attacks, use :null_session for APIs
  protect_from_forgery with: :null_session

  def create
    @author = Author.new(author_params)
    @author.author_uid = SecureRandom.uuid

    @author.save!

    render json: @author, serializer: AuthorSerializer, status: :created, location: request.original_url + @author.author_uid
  end

  def show
    render json: @author, serializer: AuthorSerializer
  end

  def update
    @author.update!(author_params)

    render json: @author, each_serializer: AuthorSerializer, status: :ok
  end

  def destroy
    @author.destroy
    head :no_content
  end

  private

  def set_author
    @author = Author.find_by(author_uid: params[:id]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Author '#{params[:id]}' not found" unless @author
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :middle_name, :info)
  end
end
