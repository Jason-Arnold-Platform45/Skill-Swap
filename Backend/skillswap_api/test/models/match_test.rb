require "test_helper"

class MatchTest < ActiveSupport::TestCase
  setup do
    @user1 = users(:one)
    @user2 = users(:two)
    @skill = @user1.skills.create!(title: "Ruby", description: "Backend", skill_type: "offer")
  end

  test "valid match creation" do
    match = Match.new(requester: @user2, provider: @user1, skill: @skill)
    assert match.valid?
  end

  test "default status is pending" do
    match = @user2.requested_matches.create!(provider: @user1, skill: @skill)
    assert_equal "pending", match.status
  end

  test "cannot match own skill" do
    match = Match.new(requester: @user1, provider: @user1, skill: @skill)
    assert_not match.valid?
    assert_includes match.errors[:base], "Cannot request your own skill"
  end

  test "requires requester, provider, and skill" do
    match = Match.new
    assert_not match.valid?
    assert_includes match.errors[:requester_id], "can't be blank"
    assert_includes match.errors[:provider_id], "can't be blank"
    assert_includes match.errors[:skill_id], "can't be blank"
  end

  test "valid status values" do
    match = Match.new(requester: @user2, provider: @user1, skill: @skill, status: "invalid")
    assert_not match.valid?
  end
end