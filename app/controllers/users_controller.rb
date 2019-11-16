class UsersController < AuthenticatedController
  ##
  # GET /users/me
  def me
    render json: current_user.to_api
  end
end
