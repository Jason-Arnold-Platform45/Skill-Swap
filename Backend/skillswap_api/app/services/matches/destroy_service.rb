module Matches
  class DestroyService
    def initialize(match:, user:)
      @match = match
      @user = user
    end

    def call
      validate_rules
      destroy_match
    end

    private

    attr_reader :match, :user

    def validate_rules
      raise UnauthorizedError unless authorized_user?
    end

    def authorized_user?
      match.requester_id == user.id || match.provider_id == user.id
    end

    def destroy_match
      match.destroy
    end

    class UnauthorizedError < StandardError
      def message
        "Only requester or provider can delete this match"
      end
    end
  end
end