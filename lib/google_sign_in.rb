require 'active_support'
require 'active_support/rails'

module GoogleSignIn
  mattr_accessor :client_id
  mattr_accessor :client_secret

  # https://tools.ietf.org/html/rfc6749#section-4.1.2.1
  authorization_request_errors = %w[
    invalid_request
    unauthorized_client
    access_denied
    unsupported_response_type
    invalid_scope
    server_error
    temporarily_unavailable
  ]

  # https://tools.ietf.org/html/rfc6749#section-5.2
  access_token_request_errors = %w[
    invalid_request
    invalid_client
    invalid_grant
    unauthorized_client
    unsupported_grant_type
    invalid_scope
  ]

  # Authorization Code Grant errors from both authorization requests
  # and access token requests.
  OAUTH2_ERRORS = authorization_request_errors | access_token_request_errors
end

require 'google_sign_in/identity'
require 'google_sign_in/engine' if defined?(Rails)
