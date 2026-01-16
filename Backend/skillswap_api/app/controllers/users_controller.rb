class UsersController < ApplicationController
  # Authentication is enforced globally by ApplicationController
  # before_action :authenticate_user!

  # GET /me
  def me
    render json: UserSerializer
      .new(current_user)
      .serializable_hash,
      status: :ok
  end
end
