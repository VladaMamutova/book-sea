class LibraryBooksController < ApplicationController
  before_action :set_library
  before_action :set_library_book, only: %i[remove_book]

  protect_from_forgery with: :null_session

  def add_book
    @library_book = LibraryBookService.new.add(@library, params[:book_uid])

    render json: { available_count: @library_book.available_count }, status: :ok
  end

  def remove_book
    available_count = LibraryBookService.new.remove(@library_book)

    render json: { available_count: available_count }, status: :ok
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
