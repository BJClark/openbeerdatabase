require File.expand_path('../boot', __FILE__)
require 'active_record/railtie'
require 'action_controller/railtie'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module OpenBeerDatabase
  class Application < Rails::Application
    config.encoding = 'utf-8'
  end
end
