class AuthController < ApplicationController
  skip_before_action :authenticate_user

  def create
    user = User.find_by(email: auth_params[:email])

    if user&.authenticate(auth_params[:password])
      token = Knock::AuthToken.new(payload: { sub: user.id }).token

      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email,
          username: user.username
        }
      }, status: :created
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def signup
    user = User.new(signup_params)

    if user.save
      token = Knock::AuthToken.new(payload: { sub: user.id }).token

      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email,
          username: user.username
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end

  def signup_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
