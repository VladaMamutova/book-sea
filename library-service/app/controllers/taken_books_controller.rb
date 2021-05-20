class TakenBooksController < ApplicationController
  before_action :set_library, except: :index
  before_action :set_library_book, only: %i[remove_book take_book return_book]

  protect_from_forgery with: :null_session

  before_action :set_library, except: :index
  before_action :set_library_book, only: %i[remove_book take_book return_book]

  protect_from_forgery with: :null_session

  def index
    if params[:user_uid]
      @taken_books = TakenBook.where(user_uid: params[:user_uid])
    else
      page = params[:page].to_i
      per_page = params[:per_page] ? params[:per_page].to_i : 20

      @taken_books = TakenBook.limit(per_page).offset(page * per_page)
    end

    render json: @taken_books, each_serializer: TakenBookSerializer
  end

  def take_book
    # todo: get user_uid from jwt token
    user_uid = '362c5679-48b8-4741-9dc1-44a7472f51f3'
    taken_book = TakenBookService.new.take(user_uid, @library_book)

    render json: taken_book, status: :ok
  end

  def return_book
    # todo: get user_uid from jwt token
    user_uid = '362c5679-48b8-4741-9dc1-44a7472f51f3'
    taken_book = TakenBookService.new.return(user_uid, @library_book, taken_book_params)

    render json: taken_book, status: :ok
  end

  private

  def taken_book_params
    params.require(:taken_book).permit(:status)
  end

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
