module JwtHelper
  def encode_token(payload)
    JWT.encode(payload, jwt_secret)
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    token = auth_header.split(" ").last if auth_header

    begin
      JWT.decode(token, jwt_secret, true, algorithm: "HS256")
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    return unless decode_token

    user_id = decode_token.first["user_id"]
    @current_user = User.find_by(id: user_id)
  end

  def logged_in?
    !!current_user
  end

  def authenticate
    unless logged_in?
      render json: { error: "Please log in" }, status: :unauthorized
    end
  end

  private

  def jwt_secret
    Rails.application.credentials.jwt_secret
  end
end
