class SkillSerializer
  def initialize(skill)
    @skill = skill
  end

  def as_json(*)
    {
      id: @skill.id,
      title: @skill.title,
      description: @skill.description,
      skill_type: @skill.skill_type,
      created_at: @skill.created_at,
      user: {
        id: @skill.user.id,
        username: @skill.user.username
      }
    }
  end
end
