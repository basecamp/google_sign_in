require_relative 'boot'

require 'rails'
require 'action_controller/railtie'
require 'rails/test_unit/railtie'
require 'google_sign_in'

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
