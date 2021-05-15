class LibrariesController < ApplicationController
  before_action :set_library, only: %i[show add_book remove_book take_book return_book]

  rescue_from StandardError, RuntimeError do |e|
    render json: { "message": e.message }, status: :internal_server_error
  end

  protect_from_forgery with: :null_session

  def show
    render json: @library
  end

  def add_book
    @library_book = LibraryService.new.add_library_book(@library, params[:book_uid])

    render json: { available_count: @library_book.available_count }, status: :ok
  end

  def remove_book
    available_count = LibraryService.new.remove_library_book(@library, params[:book_uid])

    render json: { available_count: available_count }, status: :ok
  end

  def take_book
    LibraryService.new.take_library_book(@library, params[:book_uid])

    head :ok # == render nothing: true, status: :ok
    # The head method can be used to send responses with ONLY headers to the browser.
  end

  def return_book
    LibraryService.new.return_library_book(@library, params[:book_uid])

    head :ok
  end

  private

  def set_library
    @library = Library.find_by(library_uid: params[:library_uid]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Library '#{params[:library_uid]}' not found" unless @library
  end
end
