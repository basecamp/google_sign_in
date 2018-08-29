require 'test_helper'

class GoogleSignIn::CallbacksControllerTest < ActionDispatch::IntegrationTest
  test "receiving an authorization code" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://www.example.com/login' }
    assert_response :redirect

    stub_token_request code: '4/SgCpHSVW5-Cy', access_token: 'ya29.GlwIBo', id_token: 'eyJhbGciOiJSUzI'

    get google_sign_in.callback_url(code: '4/SgCpHSVW5-Cy', state: flash[:state])
    assert_redirected_to 'http://www.example.com/login'
    assert_equal 'eyJhbGciOiJSUzI', flash[:google_sign_in_token]
  end

  test "protecting against CSRF" do
    get google_sign_in.callback_url(code: '4/SgCpHSVW5-Cy', state: 'invalid')
    assert_response :unprocessable_entity
  end

  test "protecting against open redirects" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://malicious.example.com/login' }
    assert_response :redirect

    get google_sign_in.callback_url(code: '4/SgCpHSVW5-Cy', state: flash[:state])
    assert_response :bad_request
  end

  private
    def stub_token_request(code:, **params)
      stub_request(:post, 'https://www.googleapis.com/oauth2/v3/token').
        with(body: { grant_type: 'authorization_code', code: code,
          client_id: '86179201039-eks5VfVc46WoFYyZVUDpQHeZFDRCqno3.apps.googleusercontent.com',
          client_secret: 'r(XsBajmyMddruvf$jDgLyPK', redirect_uri: 'http://www.example.com/google_sign_in/callback' }).
        to_return(status: 200, headers: { 'Content-Type' => 'application/json' }, body: JSON.generate(params))
    end
end
