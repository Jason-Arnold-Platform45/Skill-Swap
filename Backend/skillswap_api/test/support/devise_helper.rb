module DeviseHelper
  def auth_headers(user)
    post user_session_path, params: {
      user: {
        email: user.email,
        password: "Password123"
      }
    }, as: :json

    token = response.headers["Authorization"]
    { "Authorization" => token }
  end
end
