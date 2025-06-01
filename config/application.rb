# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path "../Gemfile", __dir__

require "bundler/setup"
require "rails"

require "action_controller/railtie"
require "action_view/railtie"
require "active_record/railtie"

Bundler.require(*Rails.groups)

class Stats < Rails::Application
  config.load_defaults 8.0

  config.active_record.verbose_query_logs = true
  config.eager_load = false
  config.enable_reloading = true
  config.i18n.available_locales = %i[en]
  config.i18n.default_locale = :en
  config.i18n.raise_on_missing_translations = true
end
