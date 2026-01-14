require "test_helper"

class SkillsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      username: "testuser",
      email: "test@example.com",
      password: "Password123",
      password_confirmation: "Password123"
    )
  end

  test "GET /skills returns 200 and JSON" do
    get skills_url

    assert_response :success
    assert_equal "application/json", response.media_type
  end

  test "GET /skills/:id returns 200 when skill exists" do
    skill = Skill.create!(
      title: "Ruby mentoring",
      description: "Helping beginners",
      skill_type: "offer",
      user: @user,
      deleted: nil
    )

    get skill_url(skill)

    assert_response :success
    assert_equal "application/json", response.media_type
  end

  test "GET /skills/:id returns 404 when skill does not exist" do
    get "/skills/999999"

    assert_response :not_found
  end

  test "GET /skills/:id returns 404 when skill is soft-deleted" do
    skill = Skill.create!(
      title: "Deleted skill",
      description: "Should not be visible",
      skill_type: "offer",
      user: @user,
      deleted: Time.current
    )

    get skill_url(skill)

    assert_response :not_found
  end
end
