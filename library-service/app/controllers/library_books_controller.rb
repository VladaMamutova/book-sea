class LibraryBooksController < ApplicationController
  before_action :set_library
  before_action :set_library_book, only: %i[remove_book]

  protect_from_forgery with: :null_session

  # GET /libraries/:library_uid/books
  def show_library_books
    @library_books = @library.library_books

    render json: @library_books, each_serializer: LibraryBookSerializer, status: :ok
  end

  # POST /libraries/:library_uid/book/:book_uid
  def add_book
    book_uid = params[:book_uid]
    available_count = params[:available_count].to_i
    @library_book = LibraryBookService.new.add(@library, book_uid, available_count)

    render json: { available_count: @library_book.available_count }, status: :ok
  end

  # DELETE /libraries/:library_uid/book/:book_uid
  def remove_book
    @library_book.destroy
    head :no_content
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
