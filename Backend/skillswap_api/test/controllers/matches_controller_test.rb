require "test_helper"

class MatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @requester = users(:one)
    @provider  = users(:two)

    @skill = @provider.skills.create!(
      title: "Ruby",
      description: "Backend",
      skill_type: "offer"
    )

    @match = Match.create!(
      requester: @requester,
      provider: @provider,
      skill: @skill,
      status: "pending"
    )
  end

  test "POST /matches creates match when authenticated and unique" do
    new_skill = @provider.skills.create!(
      title: "Go",
      description: "Systems programming",
      skill_type: "offer"
    )

    post "/matches",
         params: { match: { skill_id: new_skill.id } },
         headers: auth_headers_for(@requester)

    assert_response :created
  end

  test "POST /matches returns 422 when duplicate match exists" do
    post "/matches",
         params: { match: { skill_id: @skill.id } },
         headers: auth_headers_for(@requester)

    assert_response :unprocessable_entity
    assert_includes response.body, "already requested"
  end

  test "POST /matches returns 401 when unauthenticated" do
    post "/matches",
         params: { match: { skill_id: @skill.id } }

    assert_response :unauthorized
  end

  test "PUT /matches/:id updates match when provider" do
    put "/matches/#{@match.id}",
        params: { match: { status: "accepted" } },
        headers: auth_headers_for(@provider)

    assert_response :ok
    assert_equal "accepted", @match.reload.status
  end

  test "PUT /matches/:id returns 401 when not provider" do
    put "/matches/#{@match.id}",
        params: { match: { status: "accepted" } },
        headers: auth_headers_for(@requester)

    assert_response :unauthorized
  end

  test "DELETE /matches/:id deletes match when requester" do
    delete "/matches/#{@match.id}",
           headers: auth_headers_for(@requester)

    assert_response :ok
    assert_nil Match.find_by(id: @match.id)
  end

  test "DELETE /matches/:id deletes match when provider" do
    delete "/matches/#{@match.id}",
           headers: auth_headers_for(@provider)

    assert_response :ok
    assert_nil Match.find_by(id: @match.id)
  end

  test "DELETE /matches/:id returns 401 when unauthorized" do
    other_user = User.create!(
      email: "other@test.com",
      password: "password123",
      username: "otheruser"
    )

    delete "/matches/#{@match.id}",
           headers: auth_headers_for(other_user)

    assert_response :unauthorized
    assert_not_nil Match.find_by(id: @match.id)
  end
end
