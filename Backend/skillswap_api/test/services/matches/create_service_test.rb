require "test_helper"

class Matches::CreateServiceTest < ActiveSupport::TestCase
  setup do
    @requester = users(:one)
    @provider = users(:two)
    @skill = @provider.skills.create!(title: "Ruby", description: "Backend", skill_type: "offer")
  end

  test "creates match successfully" do
    service = Matches::CreateService.new(requester: @requester, skill: @skill)
    match = service.call

    assert match.persisted?
    assert_equal @requester.id, match.requester_id
    assert_equal @provider.id, match.provider_id
    assert_equal @skill.id, match.skill_id
    assert_equal "pending", match.status
  end

  test "raises error when matching own skill" do
    own_skill = @requester.skills.create!(title: "Python", description: "Backend", skill_type: "offer")
    service = Matches::CreateService.new(requester: @requester, skill: own_skill)

    assert_raises(Matches::CreateService::CannotMatchOwnSkillError) do
      service.call
    end
  end

  test "raises error when skill not found" do
    service = Matches::CreateService.new(requester: @requester, skill: nil)

    assert_raises(Matches::CreateService::SkillNotFoundError) do
      service.call
    end
  end

  test "match has default pending status" do
    service = Matches::CreateService.new(requester: @requester, skill: @skill)
    match = service.call

    assert_equal "pending", match.status
  end
end