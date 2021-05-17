class LibrariesController < ApplicationController
  before_action :set_library

  protect_from_forgery with: :null_session

  def show
    render json: @library
  end

  private

  def set_library
    @library = Library.find_by(library_uid: params[:id]) # nil if not found
    raise ActiveRecord::RecordNotFound, "Library '#{params[:library_uid]}' not found" unless @library
  end
end
