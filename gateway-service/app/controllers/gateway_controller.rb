class GatewayController < ApplicationController
  before_action :check_authorization, only: %i[find_book_in_libraries]
  before_action :check_user_rights, only: %i[take_book return_book show_rating]
  before_action :check_admin_rights, only: %i[add_book remove_book add_book_to_library remove_book_from_library]
  
  skip_before_action :verify_authenticity_token # fix!!!

  # GET /books/:book_uid
  def show_book_info
    book = GatewayService.new.get_book_info(params[:book_uid])

    render json: book, status: :ok
  end

  # GET /books
  def show_books
    books = GatewayService.new.get_books(params)

    render json: books, status: :ok
  end

  # GET /author/:author_uid
  def show_author_info
    author = GatewayService.new.get_author_info(params[:author_uid])

    render json: author, status: :ok
  end

  # GET /author/:author_uid/books
  def show_author_with_books
    author = GatewayService.new.get_author_with_books(params[:author_uid])

    render json: author, status: :ok
  end

  # POST /books
  def add_book
    book = GatewayService.new.add_book(book_params)

    render json: book, status: :created, location: request.original_url + book['book_uid']
  end

  # DELETE /books/:book_uid
  def remove_book
    GatewayService.new.remove_book(params[:book_uid])

    head :no_content
  end

  # GET /authors
  def show_authors
    authors = GatewayService.new.get_authors

    render json: authors, status: :ok
  end

  # GET /genres
  def show_genres
    genres = GatewayService.new.get_genres

    render json: genres, status: :ok
  end

  # GET /library
  def show_libraries
    libraries = LibraryService.new.show_libraries

    render json: libraries, status: :ok
  end

  # GET /library/:library_uid/books
  def show_library_books
    books = GatewayService.new.get_library_books(params[:library_uid])

    render json: books, status: :ok
  end

  # POST /library/:library_uid/book/:book_uid
  def add_book_to_library
    number = params[:number].to_i
    response = GatewayService.new.add_book_to_library(params[:book_uid], params[:library_uid], number)

    render json: response, status: :ok
  end

  # DELETE /library/:library_uid/book/:book_uid
  def remove_book_from_library
    GatewayService.new.remove_book_from_library(params[:book_uid], params[:library_uid])

    head :no_content
  end

  # POST /library/:library_uid/book/:book_uid/take
  def take_book
    taken_book = GatewayService.new.take_book(@user_uid, params[:book_uid], params[:library_uid])

    render json: taken_book, status: :ok
  end

  # POST /library/:library_uid/book/:book_uid/return
  def return_book
    status = params[:status].to_s
    LibraryService.new.return_book_to_library(@user_uid, params[:book_uid], params[:library_uid], status)

    head :ok
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

  def check_authorization
    Rails.logger.info 'Check authorization before API request'
    command = AuthorizeApiRequest.call(request.headers)
    raise Error::NotAuthorized, command.errors[:message].first if !command.success?

    @user_uid = command.result
  end

  def check_user_rights
    Rails.logger.info 'Check user rights before API request'
    command = AuthorizeApiRequest.call(request.headers, 'user')
    raise Error::NotAuthorized, command.errors[:message].first if !command.success?

    @user_uid = command.result
  end

  def check_admin_rights
    Rails.logger.info 'Check admin rights before API request'
    command = AuthorizeApiRequest.call(request.headers, 'admin')
    raise Error::NotAuthorized, command.errors[:message].first if !command.success?

    @user_uid = command.result
  end
end
