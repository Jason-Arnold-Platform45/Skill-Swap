class Skill < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :skill_type, presence: true,
                   inclusion: { in: %w[offer request] }
end
