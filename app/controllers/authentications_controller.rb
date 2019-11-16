class AuthenticationsController < ApplicationController
  def create
    user = User.find_and_authenticate(params['email'], params['password'])

    return render json: {token: user.to_token} if user.present?

    render json: {message: 'authentication fail'}, status: 401
  end
end
