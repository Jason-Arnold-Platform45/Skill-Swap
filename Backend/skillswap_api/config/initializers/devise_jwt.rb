# frozen_string_literal: true

Devise.setup do |config|
  config.jwt do |jwt|
    # Use Rails secret key base
    jwt.secret = Rails.application.credentials.secret_key_base

    # Issue JWT on login
    jwt.dispatch_requests = [
      ['POST', %r{^/users/sign_in$}]
    ]

    # Revoke JWT on logout
    jwt.revocation_requests = [
      ['DELETE', %r{^/users/sign_out$}]
    ]

    # Token expiration (24 hours)
    jwt.expiration_time = 1.day.to_i
  end
end
