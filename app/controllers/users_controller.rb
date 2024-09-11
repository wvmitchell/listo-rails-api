class UsersController < ApplicationController
  before_action :authenticate, except: :create

  def create
    user = User.new(user_params)
    user.picture =
      "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?s=200"

    begin
      user.save!
      render json: user
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def show
    render json: { email: current_user.email, picture: current_user.picture }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
