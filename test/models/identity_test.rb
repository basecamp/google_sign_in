require 'test_helper'
require 'jwt'

class GoogleSignIn::IdentityTest < ActiveSupport::TestCase
  test "client_id must be set" do
    switch_client_id_to nil do
      assert_raises(ArgumentError) { GoogleSignIn::Identity.new("some_fake_token") }
    end
  end

  test "client_id must be in the token audience" do
    assert_raises GoogleSignIn::Identity::ValidationError do
      GoogleSignIn::Identity.new(token_with(aud: "invalid"))
    end
  end

  test "token must have a valid issuer" do
    assert_raises GoogleSignIn::Identity::ValidationError do
      GoogleSignIn::Identity.new(token_with(iss: "invalid"))
    end
  end

  test "token must be signed with the correct key" do
    assert_raises GoogleSignIn::Identity::ValidationError do
      GoogleSignIn::Identity.new(token_with(key: OpenSSL::PKey::RSA.new(2048)))
    end
  end

  test "token must not be expired" do
    freeze_time do
      assert_raises GoogleSignIn::Identity::ValidationError do
        GoogleSignIn::Identity.new(token_with(iat: 10.minutes.ago.to_i, exp: 5.minutes.ago.to_i))
      end
    end
  end

  test "extracting user ID" do
    assert_equal "573222559223877", GoogleSignIn::Identity.new(token_with(sub: "573222559223877")).user_id
  end

  test "extracting name" do
    assert_equal "George Claghorn", GoogleSignIn::Identity.new(token_with(name: "George Claghorn")).name
  end

  test "extracting email address" do
    assert_equal "george@basecamp.com", GoogleSignIn::Identity.new(token_with(email: "george@basecamp.com")).email_address
  end

  test "extracting email verification status" do
    assert GoogleSignIn::Identity.new(token_with(email: "george@basecamp.com", email_verified: true)).email_verified?
    assert_not GoogleSignIn::Identity.new(token_with(email: "george@basecamp.com", email_verified: false)).email_verified?
    assert_not GoogleSignIn::Identity.new(token_with(email: "george@basecamp.com")).email_verified?
  end

  test "extracting avatar URL" do
    assert_equal "https://example.com/avatar.png",
      GoogleSignIn::Identity.new(token_with(picture: "https://example.com/avatar.png")).avatar_url
  end

  test "extracting locale" do
    assert_equal "en-US", GoogleSignIn::Identity.new(token_with(locale: "en-US")).locale
  end

  test "extracting hd on google apps identity" do
    assert_equal "basecamp.com", GoogleSignIn::Identity.new(g_suite_token_with(locale: "en-US")).hd
  end
  private
    def switch_client_id_to(value)
      previous_value = GoogleSignIn.client_id
      GoogleSignIn.client_id = value
      yield
    ensure
      GoogleSignIn.client_id = previous_value
    end

    def token_with(aud: FAKE_GOOGLE_CLIENT_ID, iss: "https://accounts.google.com", key: GOOGLE_PRIVATE_KEY, **payload)
      JWT.encode(payload.merge(aud: aud, iss: iss), key, "RS256")
    end

    def g_suite_token_with(aud: FAKE_GOOGLE_CLIENT_ID, iss: "https://accounts.google.com", key: GOOGLE_PRIVATE_KEY, **payload)
      JWT.encode(payload.merge(aud: aud, iss: iss, hd: 'basecamp.com'), key, "RS256")
    end
end
