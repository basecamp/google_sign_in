require 'rails/engine'

module GoogleSignIn
  class Engine < ::Rails::Engine
    isolate_namespace GoogleSignIn

    config.google_sign_in = ActiveSupport::OrderedOptions.new

    initializer 'google_sign_in.config' do |app|
      config.after_initialize do
        GoogleSignIn.client_id     = config.google_sign_in.client_id || app.credentials.dig(:google_sign_in, :client_id)
        GoogleSignIn.client_secret = config.google_sign_in.client_secret || app.credentials.dig(:google_sign_in, :client_secret)
      end
    end

    initializer 'google_sign_in.helpers' do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.helper GoogleSignIn::Engine.helpers
      end
    end

    initializer 'google_sign_in.mount' do |app|
      app.routes.append do
        mount GoogleSignIn::Engine, at: app.config.google_sign_in.root || 'google_sign_in'
      end
    end

    initializer 'google_sign_in.parameter_filters' do |app|
      app.config.filter_parameters << :code
    end
  end
end
