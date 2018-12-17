require_dependency 'google_sign_in/redirect_protector'

class GoogleSignIn::CallbacksController < GoogleSignIn::BaseController
  def show
    if valid_request?
      redirect_to proceed_to_url, flash: { google_sign_in_token: id_token, google_sign_in_access_token: access_token }
    else
      head :unprocessable_entity
    end
  rescue GoogleSignIn::RedirectProtector::Violation => error
    logger.error error.message
    head :bad_request
  end

  private
    def valid_request?
      flash[:state].present? && params.require(:state) == flash[:state]
    end

    def proceed_to_url
      flash[:proceed_to].tap { |url| GoogleSignIn::RedirectProtector.ensure_same_origin(url, request.url) }
    end

    def oauth_access_token
      @oauth_access_token ||= client.auth_code.get_token(params.require(:code))
    end

    def id_token
      oauth_access_token['id_token']
    end

    def access_token
      oauth_access_token.token
    end
end
