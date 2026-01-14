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
      user_id: @skill.user_id,
      created_at: @skill.created_at
    }
  end
end
