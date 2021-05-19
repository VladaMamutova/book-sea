class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users, each_serializer: UserSerializer
  end

  def create
    @user = User.create!(login: params[:login], password: params[:password], user_uid: SecureRandom.uuid)

    render json: @user, serializer: UserSerializer, status: :created, location: request.original_url + @user.user_uid
  end
end
