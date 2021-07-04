class TakenBooksController < ApplicationController
  before_action :set_library, except: %i[show_user_taken_books destroy]
  before_action :set_library_book, only: %i[take_book return_book]

  protect_from_forgery with: :null_session

  # GET taken_books/user/:user_uid
  def show_user_taken_books
    @taken_books = TakenBook.where(user_uid: params[:user_uid])

    render json: @taken_books, each_serializer: TakenBookSerializer
  end

  # POST libraries/:library_uid/book/:book_uid/take
  def take_book
    taken_book = TakenBookService.new.take(params[:user_uid], @library_book)

    render json: taken_book, status: :ok
  end

  # POST libraries/:library_uid/book/:book_uid/return
  def return_book
    TakenBookService.new.return(params[:user_uid], @library_book, params[:status])

    head :ok
  end

  # DELETE /taken_books/:taken_book_uid
  def destroy
    @taken_book = TakenBook.find_by(taken_book_uid: params[:taken_book_uid]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Taken Book '#{params[:taken_book_uid]}' not found" unless @taken_book

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
end
