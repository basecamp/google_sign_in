class GoogleSignIn::BaseController < ActionController::Base
  protect_from_forgery with: :exception

  private
    def client
      @client ||= GoogleSignIn.oauth2_client(redirect_uri: callback_url)
    end
end
