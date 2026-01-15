class Match < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :provider, class_name: "User"
  belongs_to :skill

  validates :requester_id, :provider_id, :skill_id, presence: true
  validates :status, inclusion: { in: %w(pending accepted rejected completed), message: "%{value} is not a valid status" }
  validate :cannot_match_own_skill

  private

  def cannot_match_own_skill
    return if skill.nil?
    
    if skill.user_id == requester_id
      errors.add(:base, "Cannot request your own skill")
    end
  end
end