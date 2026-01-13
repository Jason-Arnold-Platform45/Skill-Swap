require "test_helper"

class UserTest < ActiveSupport::TestCase
  def valid_user(overrides = {})
    User.new({
      username: "testuser",
      email: "test@example.com",
      password: "Password123",
      password_confirmation: "Password123"
    }.merge(overrides))
  end

  test "user is valid with valid attributes" do
    user = valid_user
    assert user.valid?
  end

  test "user is invalid without username" do
    user = valid_user(username: nil)
    assert_not user.valid?
    assert_includes user.errors[:username], "can't be blank"
  end

  test "user is invalid without email" do
    user = valid_user(email: nil)
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "user is invalid without password on create" do
    user = User.new(
      username: "testuser",
      email: "test@example.com"
    )
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "password confirmation must match" do
    user = valid_user(password_confirmation: "WrongPassword")
    assert_not user.valid?
    assert_includes user.errors[:password_confirmation], "doesn't match Password"
  end

  test "username must be unique" do
    valid_user.save!
    duplicate = valid_user
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:username], "has already been taken"
  end
end
