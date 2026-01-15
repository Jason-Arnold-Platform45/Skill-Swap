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

  ## LOGIN TESTS

  test "login succeeds with valid credentials" do
    post "/login", params: {
      auth: {
        email: @user.email,
        password: "Password123"
      }
    }, as: :json

    assert_response :created

    json = JSON.parse(response.body)
    assert json["token"].present?, "JWT token should be returned"
    assert_equal @user.username, json["user"]["username"]
  end

  test "login fails with invalid credentials" do
    post "/login", params: {
      auth: {
        email: @user.email,
        password: "WrongPassword"
      }
    }, as: :json

    assert_response :unauthorized

    json = JSON.parse(response.body)
    assert_equal "Invalid email or password", json["error"]
  end

  ## SIGNUP TESTS

  test "signup succeeds with valid params" do
    post "/signup", params: {
      user: {
        username: "newuser",
        email: "new@example.com",
        password: "Password123",
        password_confirmation: "Password123"
      }
    }, as: :json

    assert_response :created

    json = JSON.parse(response.body)
    assert json["token"].present?, "JWT token should be returned"
    assert_equal "newuser", json["user"]["username"]
  end

  test "signup fails with invalid params" do
    post "/signup", params: {
      user: {
        username: "",
        email: "bad",
        password: "123",
        password_confirmation: "456"
      }
    }, as: :json

    assert_response :unprocessable_entity
  end
end
