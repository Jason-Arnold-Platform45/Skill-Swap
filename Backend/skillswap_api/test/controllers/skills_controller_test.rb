require "test_helper"

class SkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user  = users(:one)
    @skill = skills(:one)

    sign_in @user
  end

  test "index returns skills" do
    get skills_path
    assert_response :ok
  end

  test "creates skill" do
    assert_difference("Skill.count", 1) do
      post skills_path, params: {
        skill: {
          title: "Rails",
          description: "Backend framework",
          skill_type: "offer"
        }
      }
    end

    assert_response :created
  end

  test "cannot update another user's skill" do
    sign_in users(:two)

    patch skill_path(@skill), params: {
      skill: { title: "Hacked" }
    }

    assert_response :forbidden
  end
end
