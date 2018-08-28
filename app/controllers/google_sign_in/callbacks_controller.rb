require_dependency 'google_sign_in/redirect_protector'

class GoogleSignIn::CallbacksController < GoogleSignIn::BaseController
  def show
    if valid_request?
      redirect_to proceed_to_url, flash: { google_sign_in_token: id_token }
    else
      head :unprocessable_entity
    end
  end

  private
    def valid_request?
      flash[:state].present? && params.require(:state) == flash[:state]
    end

    def proceed_to_url
      flash[:proceed_to].tap { |url| GoogleSignIn::RedirectProtector.ensure_same_origin(url, request.url) }
    end

    def id_token
      client.auth_code.get_token(params.require(:code))['id_token']
    end
end
