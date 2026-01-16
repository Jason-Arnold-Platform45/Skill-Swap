require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with valid attributes" do
    user = User.new(
      username: "testuser",
      email: "test@example.com",
      password: "Password123",
      password_confirmation: "Password123"
    )

    assert user.valid?
  end
end
