class ApplicationController < ActionController::API
  def current_user
    # find the user by the token
    # TODO: Find the user based on the token
    User.first
  end
end
