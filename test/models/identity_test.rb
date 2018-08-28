require 'test_helper'

class GoogleSignIn::IdentityTest < ActiveSupport::TestCase
  test "client_id must be set" do
    GoogleSignIn.client_id = nil
    assert_raises(ArgumentError) { GoogleSignIn::Identity.new("some_fake_token") }
  end

  test "client_id must be part of the audience" do
    # FIXME: Need to build a mock/simulate the google token to test this
  end
end
