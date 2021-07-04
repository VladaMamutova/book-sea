class UserMonitoringController < ApplicationController
  before_action :set_user_monitoring

  # GET /control/user/:user_uid
  def show
    render json: @user_monitoring, serializer: UserMonitoringSerializer
  end

  # GET /control/user/:user_uid/taken_books
  def get_taken_books
    render json: @user_monitoring.taken_books, status: :ok
  end

  # POST /control/user/:user_uid/taken_books
  def add_taken_book
    taken_book_uid = params[:taken_book_uid]
    taken_books = @user_monitoring.taken_books

    if taken_books.count >= @user_monitoring.limit
      raise Error::LimitExceeded, "The number of books taken by user: '#{params[:user_uid]}' has reached its limit (#{@user_monitoring.limit})"
    end
 
    @user_monitoring.update(taken_books: (taken_books << taken_book_uid))

    head :ok
  end

  # DELETE /control/user/:user_uid/taken_books/:taken_book_uid
  def remove_taken_book
    taken_books = @user_monitoring.taken_books
    taken_books.delete(params[:taken_book_uid])
    @user_monitoring.update(taken_books: taken_books)

    head :ok
  end

  private

  def set_user_monitoring
    @user_monitoring = UserMonitoring.find_by(user_uid: params[:user_uid]) # nil if not found
    raise ActiveRecord::RecordNotFound, "User Monitoring '#{params[:user_uid]}' not found" unless @user_monitoring
  end
end
