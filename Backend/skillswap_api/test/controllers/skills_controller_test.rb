require "test_helper"

class SkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user  = users(:one)
    @skill = skills(:one)
  end

  test "GET /skills returns 200 and JSON" do
    get skills_path
    assert_response :success
    assert_equal "application/json", response.media_type
  end

  test "GET /skills/:id returns 200 when skill exists" do
    get skill_path(@skill)
    assert_response :success
  end

  test "GET /skills/:id returns 404 when skill does not exist" do
    get skill_path(id: 999_999)
    assert_response :not_found
  end

  test "GET /skills/:id returns 404 when skill is soft-deleted" do
    @skill.update!(deleted: Time.current)

    get skill_path(@skill)
    assert_response :not_found
  end

  test "POST /skills succeeds when authenticated" do
    skill_params = {
      title: "Ruby tutoring",
      description: "Helping beginners learn Rails",
      skill_type: "offer"
    }

    post skills_path,
         params: { skill: skill_params },
         headers: auth_headers_for(@user)

    assert_response :created
  end

  test "POST /skills returns 401 when unauthenticated" do
    skill_params = {
      title: "Unauthorized skill",
      description: "Should fail",
      skill_type: "offer"
    }

    post skills_path, params: { skill: skill_params }

    assert_response :unauthorized
  end
end
