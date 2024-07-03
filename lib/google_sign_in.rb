require 'active_support'
require 'active_support/rails'
require 'oauth2'

module GoogleSignIn
  mattr_accessor :client_id
  mattr_accessor :client_secret
  mattr_accessor :authorize_url, default: "https://accounts.google.com/o/oauth2/auth"
  mattr_accessor :token_url, default: "https://oauth2.googleapis.com/token"
  mattr_accessor :oauth2_client_options, default: nil

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

  def self.oauth2_client(redirect_uri:)
    Rails.logger.debug "VZ in oauth2_client, authorize_url: #{GoogleSignIn.authorize_url}, token_url: #{GoogleSignIn.token_url}, redirect_uri: #{redirect_uri}, client options: #{GoogleSignIn.oauth2_client_options.to_h.inspect}"
    OAuth2::Client.new \
      GoogleSignIn.client_id,
      GoogleSignIn.client_secret,
      authorize_url: GoogleSignIn.authorize_url,
      token_url: GoogleSignIn.token_url,
      redirect_uri: redirect_uri,
      **GoogleSignIn.oauth2_client_options.to_h
  end
end

require 'google_sign_in/identity'
require 'google_sign_in/engine' if defined?(Rails) && !defined?(GoogleSignIn::Engine)
