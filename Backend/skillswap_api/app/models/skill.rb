class Skill < ApplicationRecord
  belongs_to :user
  has_many :matches, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :skill_type, presence: true,
                   inclusion: { in: %w[offer request] }
end
