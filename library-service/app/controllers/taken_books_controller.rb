class TakenBooksController < ApplicationController
  before_action :set_library, only: %i[take_book return_book]
  before_action :set_library_book, only: %i[take_book return_book]
  before_action :set_taken_book, only: %i[show cancel_return destroy]

  protect_from_forgery with: :null_session

  # GET taken_books/user/:user_uid
  def show_user_taken_books
    @taken_books = TakenBook.where(user_uid: params[:user_uid])

    render json: @taken_books, each_serializer: TakenBookSerializer
  end

  # GET taken_books/:taken_book_uid
  def show
    render json: @taken_book, serializer: TakenBookSerializer
  end

  # POST libraries/:library_uid/book/:book_uid/take
  def take_book
    taken_book = TakenBookService.new.take(params[:user_uid], @library_book)

    render json: taken_book, status: :ok
  end

  # POST libraries/:library_uid/book/:book_uid/return
  def return_book
    return_info = TakenBookService.new.return(params[:user_uid], @library_book, params[:status])

    render json: return_info, status: :ok
  end

  # POST /taken_books/:taken_book_uid/cancel_return
  def cancel_return
    library = Library.find_by(library_uid: @taken_book.library_uid)
    library_book = LibraryBookService.new.get_library_book(library, @taken_book.book_uid) if library.present?
    library_book.update(available_count: library_book.available_count - 1) if library_book.present?

    @taken_book.update!(status: 'new')
  end

  # DELETE /taken_books/:taken_book_uid
  def destroy
    library = Library.find_by(library_uid: @taken_book.library_uid)
    LibraryBookService.new.add_one_if_exist(library, @taken_book.book_uid)

    @taken_book.destroy

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

  def set_taken_book
    @taken_book = TakenBook.find_by(taken_book_uid: params[:taken_book_uid]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Taken Book '#{params[:taken_book_uid]}' not found" unless @taken_book
  end
end
