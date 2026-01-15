require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
  @user = User.create!(
    username: "testuser",
    email: "test@example.com",
    password: "Password123",
    password_confirmation: "Password123"
  )
end

  test "signup succeeds with valid credentials" do
    post "/signup", params: {
      auth: {
        email: @user.email,
        password: "Password123"
      }
    }, as: :json

    assert_response :created

    json = JSON.parse(response.body)
    assert json["token"].present?, "JWT token should be returned"
  end

  test "signup fails with invalid credentials" do
    post "/signup", params: {
      auth: {
        email: @user.email,
        password: "WrongPassword"
      }
    }, as: :json

    assert_response :unauthorized

    json = JSON.parse(response.body)
    assert_equal "Invalid email or password", json["error"]
  end
end
