module Matches
  class UpdateService
    def initialize(match:, user:, status:)
      @match = match
      @user = user
      @status = status
    end

    def call
      validate_rules
      update_match
    end

    private

    attr_reader :match, :user, :status

    def validate_rules
      raise UnauthorizedError unless authorized_user?
      raise InvalidStatusError unless valid_status?
    end

    def authorized_user?
      match.requester_id == user.id || match.provider_id == user.id
    end

    def valid_status?
      %w(pending accepted rejected completed).include?(status)
    end

    def update_match
      match.update!(status: status)
      match
    end

    class UnauthorizedError < StandardError
      def message
        "Only requester or provider can update this match"
      end
    end

    class InvalidStatusError < StandardError
      def message
        "Invalid status. Must be one of: pending, accepted, rejected, completed"
      end
    end
  end
end