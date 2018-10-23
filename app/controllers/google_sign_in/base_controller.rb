require 'oauth2'

class GoogleSignIn::BaseController < ActionController::Base
  protect_from_forgery with: :exception

  private
    def client
      @client ||= OAuth2::Client.new \
        GoogleSignIn.client_id,
        GoogleSignIn.client_secret,
        authorize_url: 'https://accounts.google.com/o/oauth2/auth',
        token_url: 'https://oauth2.googleapis.com/token',
        redirect_uri: callback_url
    end
end
