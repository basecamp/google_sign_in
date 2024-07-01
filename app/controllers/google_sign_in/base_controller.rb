class GoogleSignIn::BaseController < ActionController::Base
  protect_from_forgery with: :exception

  private
    def client
      @client ||= GoogleSignIn.oauth2_client(redirect_uri: callback_url(host: redirect_host_only || redirect_host))
    end

    def redirect_host_only
      Rails.application.config.action_mailer.default_url_options[:host_only]
    end

    def redirect_host
      Rails.application.config.action_mailer.default_url_options[:host]
    end
end
