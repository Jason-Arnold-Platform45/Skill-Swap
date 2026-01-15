ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests serially to avoid database deadlocks
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    # token = Knock::AuthToken.new(payload: { sub: user.id }).token
    def auth_headers_for(user)
      token = Knock::AuthToken.new(payload: { sub: user.id }).token
      {
        "Authorization" => "Bearer #{token}"
      }
    end
  end
end
