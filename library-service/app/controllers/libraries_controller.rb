class LibrariesController < ApplicationController
  before_action :set_library
  before_action :set_library_book, only: %i[remove_book take_book return_book]

  protect_from_forgery with: :null_session

  def show
    render json: @library
  end

  def add_book
    @library_book = LibraryService.new.add_library_book(@library, params[:book_uid])

    render json: { available_count: @library_book.available_count }, status: :ok
  end

  def remove_book
    available_count = LibraryService.new.remove_library_book(@library_book)

    render json: { available_count: available_count }, status: :ok
  end

  def take_book
    # todo: get user_uid from jwt token
    user_uid = SecureRandom.uuid
    taken_book = LibraryService.new.take_library_book(user_uid, @library_book)

    render json: taken_book, status: :ok
    # head :ok # == render nothing: true, status: :ok
    # The head method can be used to send responses with ONLY headers to the browser.
  end

  def return_book
    # todo: get user_uid from jwt token
    user_uid = '362c5679-48b8-4741-9dc1-44a7472f51f3'
    taken_book = LibraryService.new.return_library_book(user_uid, @library_book, params['status'])

    render json: taken_book, serializer: TakenBookSerializer, status: :ok
    # head :ok
  end

  private

  def set_library
    @library = Library.find_by(library_uid: params[:library_uid]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Library '#{params[:library_uid]}' not found" unless @library
  end

  def set_library_book
    book_uid = params[:book_uid]
    library_uid = params[:library_uid]
    @library_book = @library.library_books.find_by(book_uid: book_uid) # nil if not found
    raise ActiveRecord::RecordNotFound, "Book '#{book_uid}' not found for library '#{library_uid}'" unless @library_book
  end
end
