class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    render json: user
  end

  def show
    render json: User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :picture,
      :password,
      :password_confirmation
    )
  end
end
