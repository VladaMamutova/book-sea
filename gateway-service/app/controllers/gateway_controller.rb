class GatewayController < ApplicationController
  skip_before_action :verify_authenticity_token # fix!!!

  # GET /books/:book_uid
  def show_book_info
    book = BookService.new.get_book_info(params[:book_uid])

    render json: book, status: :ok
  end

  # GET /books
  def show_books
    book = BookService.new.get_books(params)

    render json: book, status: :ok
  end

  # GET /author/:author_uid
  def show_author_info
    author = BookService.new.get_author_info(params[:author_uid])

    render json: author, status: :ok
  end

  # GET /author/:author_uid/books
  def show_author_with_books
    author = BookService.new.get_author_with_books(params[:author_uid])

    render json: author, status: :ok
  end

  # POST /books
  def add_book
    book = BookService.new.add_book(book_params)

    render json: book, status: :created, location: request.original_url + book['book_uid']
  end

  # DELETE /books/:book_uid
  def remove_book
    BookService.new.remove_book(params[:book_uid])

    head :no_content
  end

  # GET /library/:library_uid/books
  def show_library_books
    books = GatewayService.new.get_library_books(params[:library_uid])

    render json: books, status: :ok
  end

  # POST /library/:library_uid/book/:book_uid
  def add_book_to_library
    available_count = params[:available_count].to_i
    response = GatewayService.new.add_book_to_library(params[:book_uid], params[:library_uid], available_count)

    render json: response, status: :ok
  end

  # DELETE /library/:library_uid/book/:book_uid
  def remove_book_from_library
    GatewayService.new.remove_book_from_library(params[:book_uid], params[:library_uid])

    head :ok
  end

  # POST /library/:library_uid/book/:book_uid/take
  def take_book
    taken_book = LibraryService.new.take_book_from_library(params[:book_uid], params[:library_uid])

    render json: taken_book, status: :ok
  end

  # POST /library/:library_uid/book/:book_uid/return
  def return_book
    status = params[:status].to_s
    taken_book = LibraryService.new.return_book_to_library(params[:book_uid], params[:library_uid], status)

    render json: taken_book, status: :ok
  end

  # GET /library/book/:book_uid
  def find_book_in_libraries
    book_libraries = GatewayService.new.find_book_in_libraries(params[:book_uid])

    render json: book_libraries, status: :ok
  end

  private

  def book_params
    params.permit(:name, :genre, { author: %i[first_name last_name middle_name] })
  end
end
