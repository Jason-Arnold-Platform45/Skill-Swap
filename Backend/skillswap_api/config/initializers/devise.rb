Devise.setup do |config|
  # ==> Mailer Configuration
  # Not required for API-only apps unless you add confirmable, recoverable, etc.
  config.mailer_sender = 'please-change-me@example.com'

  # ==> ORM configuration
  require 'devise/orm/active_record'

  # ==> Configuration for API-only apps
  # VERY IMPORTANT: disables HTML redirects & flash messages
  config.navigational_formats = []

  # ==> Authentication Keys
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # ==> Password Configuration
  config.stretches = Rails.env.test? ? 1 : 12
  config.password_length = 6..128

  # ==> Rememberable
  config.remember_for = 2.weeks

  # ==> JWT Configuration (handled by devise-jwt)
  # Actual JWT setup lives in config/initializers/devise_jwt.rb

  # ==> Warden
  config.warden do |manager|
    manager.intercept_401 = false
  end

  # ==> Scoped views
  config.scoped_views = false
end
