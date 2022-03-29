require 'google_sign_in/redirect_protector'

class GoogleSignIn::CallbacksController < GoogleSignIn::BaseController
  def show
    redirect_to proceed_to_url, flash: { google_sign_in: google_sign_in_response }
  rescue GoogleSignIn::RedirectProtector::Violation => e
    logger.error e.message
    head :bad_request
  end

  private

  def proceed_to_url
    flash[:proceed_to].tap { |url| GoogleSignIn::RedirectProtector.ensure_same_origin(url, request.url) }
  end

  def google_sign_in_response
    if valid_request? && params[:code].present?
      response = { id_token: id_token }
      response[:refresh_token] = refresh_token if refresh_token
      response[:access_token] = access_token unless refresh_token
      response
    else
      { error: error_message_for(params[:error]) }
    end
  rescue OAuth2::Error => e
    { error: error_message_for(e.code) }
  end

  def valid_request?
    flash[:state].present? && params[:state] == flash[:state]
  end

  def token
    @token ||= client.auth_code.get_token(params[:code])
  end

  def id_token
    token['id_token']
  end

  def access_token
    token.token
  end

  def refresh_token
    token.refresh_token
  end

  def error_message_for(error_code)
    error_code.presence_in(GoogleSignIn::OAUTH2_ERRORS) || 'invalid_request'
  end
end
