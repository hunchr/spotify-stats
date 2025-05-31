# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path "../Gemfile", __dir__

require "bundler/setup"
require "rails"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module Spotify
  class Application < Rails::Application
    config.load_defaults 8.0

    config.active_record.verbose_query_logs = true
    config.eager_load = false
    config.enable_reloading = true
  end
end
