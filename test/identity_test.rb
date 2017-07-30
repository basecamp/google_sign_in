require 'test_helper'
require 'minitest/mock'
require 'google_sign_in/identity'

class GoogleSignIn::IdentityTest < ActiveSupport::TestCase
  test "client_id must be set" do
    GoogleSignIn::Identity.client_id = nil
    assert_raises(ArgumentError) { GoogleSignIn::Identity.new("some_fake_token") }
  end

  test "client_id must be part of the audience" do
    GoogleSignIn::Identity.client_id = "MY_APP"
    GoogleIDToken::Validator.stub :new, validator = Minitest::Mock.new do
      validator.expect(:check, {"aud" => "ANOTHER_APP"}, ["some_fake_token", "MY_APP"])
      assert_raises(RuntimeError) { GoogleSignIn::Identity.new("some_fake_token") }
      validator.verify()
    end
  end

  test "client_id is part of the audience" do
    GoogleSignIn::Identity.client_id = "MY_APP"
    GoogleIDToken::Validator.stub :new, validator = Minitest::Mock.new do
      validator.expect(:check, {"aud" => "MY_APP"}, ["some_fake_token", "MY_APP"])
      assert_nothing_raised{ GoogleSignIn::Identity.new("some_fake_token") }
      validator.verify()
    end
  end
end
