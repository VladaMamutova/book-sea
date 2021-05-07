require 'securerandom'

class BooksController < ApplicationController
  before_action :set_book, only: %i[show]

  # prevent CSRF attacks, use :null_session for APIs
  protect_from_forgery with: :null_session

  def index
    page = params[:page].to_i
    per_page = params[:per_page] ? params[:per_page].to_i : 20
    @books = Book.limit(per_page).offset(page * per_page)

    render json: @books, each_serializer: BookSerializer
  end

  def create
    # TODO: check for nil, validations
    author = Author.find_by(author_params)
    genre = Genre.find_by(name: genre_params[:genre])

    @book = Book.new(book_params)
    @book.author = author
    @book.genre = genre
    @book.book_uid = SecureRandom.uuid

    @book.save

    render json: @book, each_serializer: BookSerializer, status: :created
  end

  def show
    return head :not_found unless @book

    render json: @book, serializer: BookSerializer
  end

  private

  def set_book
    @book = Book.find_by(book_uid: params[:id]) # nil if not found
  end

  # only allow a list of trusted parameters through
  def book_params
    params.require(:book).permit(:name)
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name)
  end

  def genre_params
    params.permit(:genre)
  end
end
