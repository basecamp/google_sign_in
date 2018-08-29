require 'test_helper'

class GoogleSignIn::IdentityTest < ActiveSupport::TestCase
  test "client_id must be set" do
    switch_client_id_to nil do
      assert_raises(ArgumentError) { GoogleSignIn::Identity.new("some_fake_token") }
    end
  end

  test "client_id must be part of the audience" do
    # FIXME: Need to build a mock/simulate the google token to test this
  end

  private
    def switch_client_id_to(value)
      previous_value = GoogleSignIn.client_id
      GoogleSignIn.client_id = value
      yield
    ensure
      GoogleSignIn.client_id = previous_value
    end
end
