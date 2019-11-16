##
# This controller implements authentication process as a layer
class AuthenticatedController < ApplicationController
  before_action :set_current_user!, :ensure_current_user!

  protected

  ##
  # this return a current user for current thread
  def current_user
    Thread.current['current_user']
  end

  ##
  # find and set current user by token authentication
  def set_current_user!
    Thread.current['current_user'] = User.find_by_token(request.headers['x-auth-token'])
  end

  ##
  # certificate that if not user authenticated should finish all operations
  def ensure_current_user!
    unless current_user
      render json: {message: "authentication fail"}, status: 401
    end
  end
end