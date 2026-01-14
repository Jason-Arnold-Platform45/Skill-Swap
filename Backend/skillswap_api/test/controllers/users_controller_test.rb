require "test_helper"

class UserTest < ActiveSupport::TestCase
  def valid_user(overrides = {})
    User.new(
      {
        username: "testuser",
        email: "test@example.com",
        password: "Password123",
        password_confirmation: "Password123"
      }.merge(overrides)
    )
  end

  test "should save user with valid attributes" do
    user = valid_user
    assert user.save, "User should save successfully with valid attributes"
  end

  test "should not save user without username" do
    user = valid_user(username: nil)
    assert_not user.save
    assert_includes user.errors[:username], "can't be blank"
  end

  test "should not save user with invalid email format" do
    user = valid_user(email: "invalid-email")
    assert_not user.save
    assert_includes user.errors[:email], "is invalid"
  end

  test "should not save user with duplicate email" do
    User.create!(
      username: "existinguser",
      email: "test@example.com",
      password: "Password123",
      password_confirmation: "Password123"
    )

    user = valid_user(username: "newuser")
    assert_not user.save
    assert_includes user.errors[:email], "has already been taken"
  end

  test "should not save user with short password" do
    user = valid_user(
      password: "short",
      password_confirmation: "short"
    )
    assert_not user.save
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"
  end
end
