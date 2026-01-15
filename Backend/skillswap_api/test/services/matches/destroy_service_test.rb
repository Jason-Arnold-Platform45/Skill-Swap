require "test_helper"

class Matches::DestroyServiceTest < ActiveSupport::TestCase
  setup do
    @requester = users(:one)
    @provider = users(:two)
    @skill = @provider.skills.create!(title: "Ruby", description: "Backend", skill_type: "offer")
    @match = Match.create!(requester: @requester, provider: @provider, skill: @skill)
  end

  test "requester can delete match" do
    service = Matches::DestroyService.new(match: @match, user: @requester)
    service.call

    assert_nil Match.find_by(id: @match.id)
  end

  test "provider can delete match" do
    service = Matches::DestroyService.new(match: @match, user: @provider)
    service.call

    assert_nil Match.find_by(id: @match.id)
  end

  test "unauthorized user cannot delete match" do
    other_user = User.create!(email: "other@test.com", password: "password123", username: "otheruser")
    service = Matches::DestroyService.new(match: @match, user: other_user)

    assert_raises(Matches::DestroyService::UnauthorizedError) do
      service.call
    end

    assert_not_nil Match.find_by(id: @match.id)
  end
end