class GatewayController < ApplicationController
  skip_before_action :verify_authenticity_token # fix!!!

  # GET /books/:book_uid
  def show_book_info
    book = BooksService.new.get_book_info(params[:book_uid])

    render json: book, status: :ok
  end

  # GET /books
  def show_books
    book = BooksService.new.get_books(params)

    render json: book, status: :ok
  end

  # GET /author/:author_uid
  def show_author_info
    author = BooksService.new.get_author_info(params[:author_uid])

    render json: author, status: :ok
  end

  # GET /author/:author_uid/books
  def show_author_with_books
    author = BooksService.new.get_author_with_books(params[:author_uid])

    render json: author, status: :ok
  end

  # POST /books
  def add_book
    book = BooksService.new.add_book(book_params)

    render json: book, status: :created, location: request.original_url + book['book_uid']
  end

  # DELETE /books/:book_uid
  def remove_book
    BooksService.new.remove_book(params[:book_uid])

    head :no_content
  end

  private

  def book_params
    params.permit(:name, :genre, { author: %i[first_name last_name middle_name] })
  end
end
