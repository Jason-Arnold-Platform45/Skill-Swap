module Matches
  class CreateService
    def initialize(requester:, skill:)
      @requester = requester
      @skill = skill
    end

    def call
      validate_rules
      create_match
    end
    
    private

    attr_reader :requester, :skill

    def validate_rules
      raise SkillNotFoundError if skill.nil?
      raise CannotMatchOwnSkillError if own_skill?
    end

    def own_skill?
      skill.user_id == requester.id
    end

    def create_match
      Match.create!(
        requester: requester,
        provider: skill.user,
        skill: skill,
        status: "pending"
      )
    end

    class CannotMatchOwnSkillError < StandardError
      def message
        "Cannot request your own skill"
      end
    end

    class SkillNotFoundError < StandardError
      def message
        "Skill not found"
      end
    end
  end
end