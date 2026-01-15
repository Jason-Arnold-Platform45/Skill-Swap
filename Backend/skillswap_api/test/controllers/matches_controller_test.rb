require "test_helper"

class MatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @requester = users(:one)
    @provider = users(:two)
    @skill = @provider.skills.create!(title: "Ruby", description: "Backend", skill_type: "offer")
    @match = Match.create!(requester: @requester, provider: @provider, skill: @skill)
  end

  test "POST /matches creates match when authenticated" do
    other_skill = @provider.skills.create!(title: "Python", description: "Backend", skill_type: "offer")
    post "/matches",
         params: { skill_id: other_skill.id },
         headers: auth_headers_for(@requester)

    assert_response :created
  end

  test "POST /matches returns 401 when unauthenticated" do
    post "/matches", params: { skill_id: @skill.id }

    assert_response :unauthorized
  end

  test "PUT /matches/:id updates match when authorized" do
    put "/matches/#{@match.id}",
        params: { match: { status: "accepted" } },
        headers: auth_headers_for(@requester)

    assert_response :ok
    assert_equal "accepted", @match.reload.status
  end

  test "PUT /matches/:id returns 403 when unauthorized" do
    other_user = User.create!(email: "other@test.com", password: "password123", username: "otheruser")
    put "/matches/#{@match.id}",
        params: { match: { status: "accepted" } },
        headers: auth_headers_for(other_user)

    assert_response :forbidden
  end

  test "DELETE /matches/:id deletes match when authorized" do
    delete "/matches/#{@match.id}",
           headers: auth_headers_for(@requester)

    assert_response :no_content
    assert_nil Match.find_by(id: @match.id)
  end

  test "DELETE /matches/:id returns 403 when unauthorized" do
    other_user = User.create!(email: "other@test.com", password: "password123", username: "otheruser")
    delete "/matches/#{@match.id}",
           headers: auth_headers_for(other_user)

    assert_response :forbidden
  end
end