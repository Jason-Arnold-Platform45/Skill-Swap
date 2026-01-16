class AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:login, :signup]

  # POST /signup
  def signup
    user = User.new(signup_params)

    if user.save
      token = encode_jwt(user)

      render json: {
        token: token,
        user: UserSerializer.new(user).serializable_hash
      }, status: :created
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_for_database_authentication(email: auth_params[:email])

    unless user&.valid_password?(auth_params[:password])
      return render json: { error: "Invalid email or password" },
                    status: :unauthorized
    end

    token = encode_jwt(user)

    render json: {
      token: token,
      user: UserSerializer.new(user).serializable_hash
    }, status: :ok
  end

  # DELETE /logout
  def logout
    render json: { message: "Logged out successfully" }, status: :ok
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end

  def signup_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end

  def encode_jwt(user)
    Warden::JWTAuth::UserEncoder.new.call(
      user,
      :user,
      nil
    ).first
  end
end
