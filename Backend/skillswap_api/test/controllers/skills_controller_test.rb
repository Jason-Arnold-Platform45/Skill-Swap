require "test_helper"

class SkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user  = users(:one)
    @other_user = users(:two)
    @skill = skills(:one)
    @skill.update!(user_id: @user.id)
  end

  test "GET /skills returns 200 and JSON" do
    get "/skills"
    assert_response :success
    assert_equal "application/json", response.media_type
  end

  test "GET /skills/:id returns 200 when skill exists" do
    get "/skills/#{@skill.id}"
    assert_response :success
  end

  test "GET /skills/:id returns 404 when skill does not exist" do
    get "/skills/999999"
    assert_response :not_found
  end

  test "GET /skills/:id returns 404 when skill is soft-deleted" do
    @skill.update!(deleted: Time.current)
    get "/skills/#{@skill.id}"
    assert_response :not_found
  end

  test "POST /skills succeeds when authenticated" do
    skill_params = {
      title: "Ruby tutoring",
      description: "Helping beginners learn Rails",
      skill_type: "offer"
    }

    post "/skills",
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

    post "/skills", params: { skill: skill_params }

    assert_response :unauthorized
  end

  test "PUT /skills/:id succeeds when owner" do
    put "/skills/#{@skill.id}",
        params: { skill: { title: "Updated Ruby" } },
        headers: auth_headers_for(@user)

    assert_response :ok
    assert_equal "Updated Ruby", @skill.reload.title
  end

  test "PUT /skills/:id returns 403 when non-owner" do
    put "/skills/#{@skill.id}",
        params: { skill: { title: "Updated Ruby" } },
        headers: auth_headers_for(@other_user)

    assert_response :forbidden
    assert_equal @skill.title, @skill.reload.title
  end

  test "PUT /skills/:id returns 401 when unauthenticated" do
    put "/skills/#{@skill.id}",
        params: { skill: { title: "Updated Ruby" } }

    assert_response :unauthorized
  end

  test "DELETE /skills/:id succeeds when owner" do
    delete "/skills/#{@skill.id}",
           headers: auth_headers_for(@user)

    assert_response :no_content
    assert_nil Skill.find_by(id: @skill.id)
  end

  test "DELETE /skills/:id returns 403 when non-owner" do
    delete "/skills/#{@skill.id}",
           headers: auth_headers_for(@other_user)

    assert_response :forbidden
    assert_not_nil Skill.find_by(id: @skill.id)
  end

  test "DELETE /skills/:id returns 401 when unauthenticated" do
    delete "/skills/#{@skill.id}"

    assert_response :unauthorized
  end
end