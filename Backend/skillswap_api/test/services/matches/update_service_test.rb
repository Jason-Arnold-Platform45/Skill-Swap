require "test_helper"

class Matches::UpdateServiceTest < ActiveSupport::TestCase
  setup do
    @requester = users(:one)
    @provider = users(:two)
    @skill = @provider.skills.create!(title: "Ruby", description: "Backend", skill_type: "offer")
    @match = Match.create!(requester: @requester, provider: @provider, skill: @skill, status: "pending")
  end

  test "requester can update match status" do
    service = Matches::UpdateService.new(match: @match, user: @requester, status: "accepted")
    updated_match = service.call

    assert_equal "accepted", updated_match.status
  end

  test "provider can update match status" do
    service = Matches::UpdateService.new(match: @match, user: @provider, status: "rejected")
    updated_match = service.call

    assert_equal "rejected", updated_match.status
  end

  test "unauthorized user cannot update match" do
    other_user = User.create!(email: "other@test.com", password: "password123", username: "otheruser")
    service = Matches::UpdateService.new(match: @match, user: other_user, status: "accepted")

    assert_raises(Matches::UpdateService::UnauthorizedError) do
      service.call
    end
  end

  test "invalid status raises error" do
    service = Matches::UpdateService.new(match: @match, user: @requester, status: "invalid")

    assert_raises(Matches::UpdateService::InvalidStatusError) do
      service.call
    end
  end

  test "valid statuses are accepted" do
    %w(pending accepted rejected completed).each do |status|
      skill = @provider.skills.create!(title: "Skill-#{status}", description: "Test", skill_type: "offer")
      match = Match.create!(requester: @requester, provider: @provider, skill: skill)
      service = Matches::UpdateService.new(match: match, user: @requester, status: status)
      
      assert_equal status, service.call.status
    end
  end
end