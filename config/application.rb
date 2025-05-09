# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require "active_job/railtie"
require 'active_record/railtie'
# require "active_storage/engine"
require 'action_controller/railtie'
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require 'action_view/railtie'
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BowlingScorekeeper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    config.active_record.cache_versioning = false
    config.active_record.schema_format = :sql

    config.log_level = :debug
    config.log_tags = [:subdomain, :uuid]
    config.logger = Logger.new($stdout)

    config.hosts = %w[localhost:3000 0.0.0.0:3000]

    config.autoload_lib(ignore: %w[assets tasks])

    config.api_only = true
  end
end
