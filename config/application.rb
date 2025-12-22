require_relative "boot"

require "logger"
require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KindeExampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Configure Redis as the default store
    #config.cache_store = :redis_cache_store, { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1") }

    # Cookie encryption rotation configuration
    # Commenting out cookie rotation configuration as it's not needed for the starter kit
    # If you need to rotate cookie encryption keys, uncomment and use the following:
    # require 'securerandom'
    # old_salt = SecureRandom.random_bytes(64)
    # old_key = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base).generate_key(old_salt)
    # config.action_dispatch.encrypted_cookie_rotations = [[old_salt, old_key]]

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
