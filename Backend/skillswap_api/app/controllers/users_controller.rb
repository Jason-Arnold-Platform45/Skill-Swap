class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  # POST /signup
  def create
    user = User.new(signup_params)

    if user.save
      token = JwtService.encode(user)

      render json: {
        token: token,
        user: UserSerializer.new(user).serializable_hash
      }, status: :created
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # GET /me
  def me
    render json: UserSerializer
      .new(current_user)
      .serializable_hash,
      status: :ok
  end

  private

    def signup_params
      params.require(:user).permit(
        :username,
        :email,
        :password,
        :password_confirmation
      )
    end
end
