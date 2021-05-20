require 'securerandom'

class BooksController < ApplicationController
  before_action :set_book, only: %i[show update destroy]

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

    genre = Genre.find_by(name: params[:genre])
    raise ActiveRecord::RecordNotFound, "Genre '#{params[:genre]}' not found" unless genre

    @book = Book.new(book_params)
    @book.author = author
    @book.genre = genre
    @book.book_uid = SecureRandom.uuid

    @book.save!

    render json: @book, serializer: BookSerializer, status: :created, location: request.original_url + @book.book_uid
  end

  def show
    render json: @book, serializer: BookSerializer
  end

  def update
    ActiveRecord::Base.transaction do
      @book.update!(book_params) unless params[:book].empty?

      if params[:author]
        author = Author.find_by(author_params)
        raise ActiveRecord::RecordNotFound, "Author (#{params_to_string(author_params)}) not found" unless author

        @book.update!(author: author)
      end

      if params[:genre]
        genre = Genre.find_by(name: params[:genre])
        raise ActiveRecord::RecordNotFound, "Genre '#{params[:genre]}' not found" unless genre

        @book.update!(genre: genre)
      end
    end

    render json: @book, each_serializer: BookSerializer, status: :ok
  end

  def destroy
    @book.destroy
    head :no_content
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

  def params_to_string(params)
    hash = params.to_h
    hash.map { |key, value| "#{key.gsub('_', ' ')}: '#{value}'" }.join(', ')
  end
end