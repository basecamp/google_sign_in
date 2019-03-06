require_dependency 'google_sign_in/redirect_protector'

class GoogleSignIn::CallbacksController < GoogleSignIn::BaseController
  def show
    if valid_request?
      redirect_to proceed_to_url, flash: google_sign_in_response
    else
      head :unprocessable_entity
    end
  rescue GoogleSignIn::RedirectProtector::Violation => error
    logger.error error.message
    head :bad_request
  end

  private
    def valid_request?
      flash[:state].present? && params[:state] == flash[:state]
    end

    def proceed_to_url
      flash[:proceed_to].tap { |url| GoogleSignIn::RedirectProtector.ensure_same_origin(url, request.url) }
    end

    def google_sign_in_response
      if params[:code].present?
        { google_sign_in_token: id_token }
      else
        { google_sign_in_error: error_message }
      end
    end

    def id_token
      client.auth_code.get_token(params[:code])['id_token']
    end

    def error_message
      params[:error].presence_in(GoogleSignIn::OAUTH2_ERRORS) || "invalid_request"
    end
end
