require 'rails/engine'

module GoogleSignIn
  class Engine < ::Rails::Engine
    initializer 'google_sign_in.helper' do
      ActiveSupport.on_load :action_controller do
        require 'google_sign_in/helper'
        ActionController::Base.helper GoogleSignIn::Helper
      end
    end

    initializer 'google_sign_in.logger' do
      config.after_initialize do
        GoogleSignIn::Identity.logger = Rails.logger
      end
    end
  end
end
