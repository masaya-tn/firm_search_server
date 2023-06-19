class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.all()
    render json: { users: users }
  end

  def update
    render json: {message: 'error'} if current_user.admin == false
    @user = User.find(params[:user][:id])
    @params = params.require(:user).permit(:name, :email, :admin)
    @user.update!(name: @params[:name], email: @params[:email], admin: @params[:admin], uid: @params[:uid])
    render json: {message: 'success'}
  end

  def destroy
    render json: {message: 'error'} if current_user.admin == false
    @user = User.find(params[:id])
    @user.destroy!
    render json: {message: 'success'}
  end
end