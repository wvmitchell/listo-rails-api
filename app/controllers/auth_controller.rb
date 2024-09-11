class AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token =
        encode_token(
          { user_id: user.id, email: user.email, picture: user.picture }
        )
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
