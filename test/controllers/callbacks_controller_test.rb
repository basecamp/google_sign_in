require 'test_helper'

class GoogleSignIn::CallbacksControllerTest < ActionDispatch::IntegrationTest
  test "receiving an authorization code" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://www.example.com/login' }
    assert_response :redirect

    stub_token_request code: '4/SgCpHSVW5-Cy', access_token: 'ya29.GlwIBo', id_token: 'eyJhbGciOiJSUzI'

    get google_sign_in.callback_url(code: '4/SgCpHSVW5-Cy', state: flash[:state])
    assert_redirected_to 'http://www.example.com/login'
    assert_equal 'eyJhbGciOiJSUzI', flash[:google_sign_in_token]
    assert_nil flash[:google_sign_in_error]
  end

  GoogleSignIn::OAUTH2_ERRORS.each do |error|
    test "receiving an authorization error: #{error}" do
      post google_sign_in.authorization_url, params: { proceed_to: 'http://www.example.com/login' }
      assert_response :redirect

      get google_sign_in.callback_url(error: error, state: flash[:state])
      assert_redirected_to 'http://www.example.com/login'
      assert_nil flash[:google_sign_in_token]
      assert_equal error, flash[:google_sign_in_error]
    end
  end

  test "receiving an invalid authorization error" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://www.example.com/login' }
    assert_response :redirect

    get google_sign_in.callback_url(error: 'unknown error code', state: flash[:state])
    assert_redirected_to 'http://www.example.com/login'
    assert_nil flash[:google_sign_in_token]
    assert_equal "invalid_request", flash[:google_sign_in_error]
  end

  test "receiving neither code nor error" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://www.example.com/login' }
    assert_response :redirect

    get google_sign_in.callback_url(state: flash[:state])
    assert_redirected_to 'http://www.example.com/login'
    assert_nil flash[:google_sign_in_token]
    assert_equal 'invalid_request', flash[:google_sign_in_error]
  end

  test "protecting against CSRF without flash state" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://www.example.com/login' }
    assert_response :redirect

    get google_sign_in.callback_url(code: '4/SgCpHSVW5-Cy', state: 'invalid')
    assert_redirected_to 'http://www.example.com/login'
    assert_nil flash[:google_sign_in_token]
    assert_equal 'invalid_request', flash[:google_sign_in_error]
  end

  test "protecting against CSRF with invalid state" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://www.example.com/login' }
    assert_response :redirect
    assert_not_nil flash[:state]

    get google_sign_in.callback_url(code: '4/SgCpHSVW5-Cy', state: 'invalid')
    assert_redirected_to 'http://www.example.com/login'
    assert_nil flash[:google_sign_in_token]
    assert_equal 'invalid_request', flash[:google_sign_in_error]
  end

  test "protecting against CSRF with missing state" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://www.example.com/login' }
    assert_response :redirect
    assert_not_nil flash[:state]

    get google_sign_in.callback_url(code: '4/SgCpHSVW5-Cy')
    assert_redirected_to 'http://www.example.com/login'
    assert_nil flash[:google_sign_in_token]
    assert_equal 'invalid_request', flash[:google_sign_in_error]
  end

  test "protecting against open redirects" do
    post google_sign_in.authorization_url, params: { proceed_to: 'http://malicious.example.com/login' }
    assert_response :redirect

    get google_sign_in.callback_url(code: '4/SgCpHSVW5-Cy', state: flash[:state])
    assert_response :bad_request
  end

  private
    def stub_token_request(code:, **params)
      stub_request(:post, 'https://oauth2.googleapis.com/token').
        with(body: { grant_type: 'authorization_code', code: code,
          client_id: FAKE_GOOGLE_CLIENT_ID, client_secret: FAKE_GOOGLE_CLIENT_SECRET,
          redirect_uri: 'http://www.example.com/google_sign_in/callback' }).
        to_return(status: 200, headers: { 'Content-Type' => 'application/json' }, body: JSON.generate(params))
    end
end
