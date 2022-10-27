require 'rails/engine'
require 'google_sign_in' unless defined?(GoogleSignIn)

module GoogleSignIn
  class Engine < ::Rails::Engine
    isolate_namespace GoogleSignIn

    # Set default config so apps can modify rather than starting from nil, e.g.
    #
    #   config.google_sign_in.authorize_url += "?disallow_webview=true"
    #
    config.google_sign_in = ActiveSupport::OrderedOptions.new.update \
      authorize_url: GoogleSignIn.authorize_url,
      token_url: GoogleSignIn.token_url

    initializer 'google_sign_in.config' do |app|
      config.after_initialize do
        GoogleSignIn.client_id     = config.google_sign_in.client_id || app.credentials.dig(:google_sign_in, :client_id)
        GoogleSignIn.client_secret = config.google_sign_in.client_secret || app.credentials.dig(:google_sign_in, :client_secret)
        GoogleSignIn.authorize_url = config.google_sign_in.authorize_url
        GoogleSignIn.token_url     = config.google_sign_in.token_url

        GoogleSignIn.oauth2_client_options = config.google_sign_in.oauth2_client_options
      end
    end

    config.to_prepare do
      ActionController::Base.helper GoogleSignIn::Engine.helpers
    end

    initializer 'google_sign_in.mount' do |app|
      app.routes.prepend do
        mount GoogleSignIn::Engine, at: app.config.google_sign_in.root || 'google_sign_in'
      end
    end

    initializer 'google_sign_in.parameter_filters' do |app|
      app.config.filter_parameters << :code
    end
  end
end
