require 'securerandom'

class BooksController < ApplicationController
  before_action :set_book, only: %i[show]

  # prevent CSRF attacks, use :null_session for APIs
  protect_from_forgery with: :null_session

  def index
    if params[:author_id] # /authors/{author_uid}/books
      @author = Author.find_by(author_uid: params[:author_id])
      raise ActiveRecord::RecordNotFound, "Author '#{params[:author_id]}' not found" unless @author

      render json: @author, serializer: AuthorWithBooksSerializer
    else # /books
      page = params[:page].to_i
      per_page = params[:per_page] ? params[:per_page].to_i : 20

      @books = Book.limit(per_page).offset(page * per_page)
      render json: @books, each_serializer: BookSerializer
    end
  end

  def create
    author = Author.find_by(author_params)
    raise ActiveRecord::RecordNotFound, "Author (#{params_to_string(author_params)}) not found" unless author

    genre = Genre.find_by(name: genre_params[:genre])
    raise ActiveRecord::RecordNotFound, "Genre '#{genre_params[:genre]}' not found" unless genre

    @book = Book.new(book_params)
    @book.author = author
    @book.genre = genre
    @book.book_uid = SecureRandom.uuid

    raise Error::RecordInvalid, @book.errors unless @book.valid?

    @book.save

    render json: @book, each_serializer: BookSerializer, status: :created
  end

  def show
    render json: @book, serializer: BookSerializer
  end

  private

  def set_book
    @book = Book.find_by(book_uid: params[:id]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Book '#{params[:id]}' not found" unless @book
  end

  # only allow a list of trusted parameters through
  def book_params
    params.require(:book).permit(:name)
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :middle_name)
  end

  def genre_params
    params.permit(:genre)
  end

  def params_to_string(params)
    hash = params.to_h
    hash.map { |key, value| "#{key.gsub('_', ' ')}: '#{value}'" }.join(', ')
  end
end
