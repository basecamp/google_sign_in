require 'active_support'
require 'active_support/rails'

module GoogleSignIn
  mattr_accessor :client_id
  mattr_accessor :client_secret

  mattr_accessor :logger, default: Logger.new(STDOUT)
end

require 'google_sign_in/identity'
require 'google_sign_in/engine' if defined?(Rails)
