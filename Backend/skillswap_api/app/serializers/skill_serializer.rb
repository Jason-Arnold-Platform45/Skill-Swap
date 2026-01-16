class SkillSerializer
  include JSONAPI::Serializer

  set_type :skill

  attributes :title, :description, :skill_type, :taken

  belongs_to :user
end
