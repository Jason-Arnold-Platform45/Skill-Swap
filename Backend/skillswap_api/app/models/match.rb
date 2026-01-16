class Match < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :provider, class_name: "User"
  belongs_to :skill

  validates :requester_id, :provider_id, :skill_id, presence: true
  validates :status, inclusion: { in: %w[pending accepted rejected completed] }

  validates :skill_id, uniqueness: {
    scope: :requester_id,
    message: "has already been requested by you"
  }

  validate :cannot_match_own_skill

  scope :for_user, ->(user) {
    includes(:skill, :requester, :provider)
      .where("requester_id = :id OR provider_id = :id", id: user.id)
  }

  private

  def cannot_match_own_skill
    return if skill.nil?
    errors.add(:base, "Cannot request your own skill") if skill.user_id == requester_id
  end
end
