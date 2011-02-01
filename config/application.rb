require File.expand_path("../boot", __FILE__)
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(:default, Rails.env) if defined?(Bundler)

module OpenBeerDatabase
  class Application < Rails::Application
    config.encoding  = "utf-8"
    config.time_zone = "UTC"
    config.middleware.use Rack::JSONP
    config.after_initialize do
      require "./lib/extensions/activemodel/errors"
    end
  end
end
