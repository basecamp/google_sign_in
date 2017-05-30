require 'rails/railtie'
require 'google_sign_in/helper'

module GoogleSignIn
  class Engine < ::Rails::Engine
    initializer :google_sign_in do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :helper, GoogleSignIn::Helper
      end
    end
  end
end
