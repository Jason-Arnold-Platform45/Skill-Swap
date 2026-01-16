require "test_helper"

class MatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @requester = users(:one)
    @provider  = users(:two)
    @skill     = skills(:one)
  end

  test "cannot create match without jwt auth" do
    assert_no_difference("Match.count") do
      post matches_path, params: {
        match: { skill_id: @skill.id }
      }
    end

    assert_response :unauthorized
  end

  test "cannot request own skill" do
    sign_in users(:one)

    own_skill = Skill.create!(
      title: "My Skill",
      description: "Something I offer",
      skill_type: "offer",
      user: users(:one)
    )

    assert_no_difference("Match.count") do
      post matches_path, params: {
        match: { skill_id: own_skill.id }
      }
    end

    assert_response :unprocessable_entity
  end


end
