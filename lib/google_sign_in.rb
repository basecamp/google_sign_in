require 'active_support'
require 'active_support/rails'

module GoogleSignIn
  mattr_accessor :client_id
  mattr_accessor :client_secret

  # https://tools.ietf.org/html/rfc6749#section-4.1.2.1
  OAUTH2_ERRORS = %w[
    invalid_request
    unauthorized_client
    access_denied
    unsupported_response_type
    invalid_scope
    server_error
    temporarily_unavailable
  ]
end

require 'google_sign_in/identity'
require 'google_sign_in/engine' if defined?(Rails)
