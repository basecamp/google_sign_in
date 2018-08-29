require 'test_helper'

class GoogleSignIn::AuthorizationsControllerTest < ActionDispatch::IntegrationTest
  test "redirecting to Google for authorization" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://www.example.com/login' }
    assert_response :redirect
    assert_match 'https://accounts.google.com/o/oauth2/auth', response.location

    params = query_params_from(response.location)
    assert_equal '86179201039-eks5VfVc46WoFYyZVUDpQHeZFDRCqno3.apps.googleusercontent.com', params[:client_id]
    assert_equal 'login', params[:prompt]
    assert_equal 'code', params[:response_type]
    assert_equal 'http://www.example.com/google_sign_in/callback', params[:redirect_uri]
    assert_equal 'openid profile email', params[:scope]
    assert_match /[A-Za-z0-9+\/]{22}==/, params[:state]

    assert_equal 'http://www.example.com/login', flash[:proceed_to]
    assert_equal params[:state], flash[:state]
  end

  private
    def query_params_from(url)
      Rack::Utils.parse_query(query_from(url)).symbolize_keys
    end

    def query_from(url)
      URI(url).query
    end
end
