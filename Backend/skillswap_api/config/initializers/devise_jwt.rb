# frozen_string_literal: true

Devise.setup do |config|
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.secret_key_base

    jwt.dispatch_requests = [
      ['POST', %r{^/session$}],
      ['POST', %r{^/signup$}]
    ]

    jwt.revocation_requests = [
      ['DELETE', %r{^/session$}]
    ]

    jwt.expiration_time = 5.minutes.to_i
  end

  config.navigational_formats = []
end
