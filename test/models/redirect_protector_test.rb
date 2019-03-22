require 'test_helper'
require 'google_sign_in/redirect_protector'

class GoogleSignIn::RedirectProtectorTest < ActiveSupport::TestCase
  test "disallows URL target with different host than source" do
    assert_raises GoogleSignIn::RedirectProtector::Violation do
      GoogleSignIn::RedirectProtector.ensure_same_origin 'https://malicious.example.com', 'https://basecamp.com'
    end
  end

  test "disallows URL target with different port than source" do
    assert_raises GoogleSignIn::RedirectProtector::Violation do
      GoogleSignIn::RedirectProtector.ensure_same_origin 'https://basecamp.com:10443', 'https://basecamp.com'
    end
  end

  test "disallows URL target with different protocol than source" do
    assert_raises GoogleSignIn::RedirectProtector::Violation do
      GoogleSignIn::RedirectProtector.ensure_same_origin 'http://basecamp.com', 'https://basecamp.com'
    end
  end

  test "disallows empty URL target" do
    assert_raises GoogleSignIn::RedirectProtector::Violation do
      GoogleSignIn::RedirectProtector.ensure_same_origin nil, 'https://basecamp.com'
    end
  end

  test "allows URL target with same origin as source" do
    assert_nothing_raised do
      GoogleSignIn::RedirectProtector.ensure_same_origin 'https://basecamp.com', 'https://basecamp.com'
    end
  end

  test "allows path target" do
    assert_nothing_raised do
      GoogleSignIn::RedirectProtector.ensure_same_origin '/callback', 'https://basecamp.com'
    end
  end
end
