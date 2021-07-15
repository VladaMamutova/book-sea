class UsersController < ApplicationController
  def index
    check_admin_rights

    @users = User.all
    render json: @users, each_serializer: UserSerializer
  end

  def show
    check_admin_rights

    @user = User.find_by(user_uid: params[:id])
    raise ActiveRecord::RecordNotFound, "User '#{params[:id]}' not found" unless @user

    render json: @user, serializer: UserSerializer
  end

  def create
    check_admin_rights

    @user = User.new(user_params)
    @user.password = params[:password]
    @user.user_uid = SecureRandom.uuid
    @user.save!

    render json: @user, serializer: UserSerializer, status: :created, location: request.original_url + @user.user_uid
  end

  private

  def user_params
    params.require(:user).permit(:login, :role)
  end

  def check_admin_rights
    command = AuthorizeApiRequest.call(request.headers, 'admin')
    return if command.success?

    raise ExceptionHandler::NotAuthorized, command.errors[:message].first
  end
end
