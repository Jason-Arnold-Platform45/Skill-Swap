require "test_helper"

class SkillTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @skill = Skill.new(
      title: "Ruby on Rails",
      description: "I can teach Rails basics",
      skill_type: "offer",
      user: @user
    )
  end

  ## VALIDATIONS

  test "skill is valid with valid attributes" do
    assert @skill.valid?
  end

  test "title must be present" do
    @skill.title = ""
    assert_not @skill.valid?
  end

  test "description must be present" do
    @skill.description = ""
    assert_not @skill.valid?
  end

  test "skill_type must be present" do
    @skill.skill_type = nil
    assert_not @skill.valid?
  end

  test "skill_type must be offer or request" do
    @skill.skill_type = "teach"
    assert_not @skill.valid?
  end

  ## ASSOCIATIONS

  test "skill belongs to user" do
    assert_respond_to @skill, :user
  end
end
