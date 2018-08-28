require 'active_support'
require 'active_support/rails'

module GoogleSignIn
  mattr_accessor :client_id
  mattr_accessor :client_secret
end

require 'google_sign_in/identity'
require 'google_sign_in/engine' if defined?(Rails)
