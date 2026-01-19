class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  # POST /login
  def create
    user = User.find_for_database_authentication(email: auth_params[:email])

    unless user&.valid_password?(auth_params[:password])
      return render json: { error: "Invalid email or password" },
                    status: :unauthorized
    end

    sign_in(user, store: false)

    render json: {
      # token: token,
      user: UserSerializer.new(user).serializable_hash
    }, status: :ok
  end

  # DELETE /logout
  def destroy
    sign_out(current_user)
    render json: { message: "Logged out successfully" }, status: :ok
  end

  private

    def auth_params
      params.require(:auth).permit(:email, :password)
    end
end
