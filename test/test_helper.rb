ENV['RAILS_ENV'] = 'test'

FAKE_GOOGLE_CLIENT_ID = '86179201039-eks5VfVc46WoFYyZVUDpQHeZFDRCqno3.apps.googleusercontent.com'
FAKE_GOOGLE_CLIENT_SECRET = 'r(XsBajmyMddruvf$jDgLyPK'

require_relative '../test/dummy/config/environment'

require 'rails/test_help'
require 'webmock/minitest'
require 'byebug'

require 'openssl'
GOOGLE_PRIVATE_KEY = OpenSSL::PKey::RSA.new(File.read(File.expand_path('key.pem', __dir__)))
GOOGLE_X509_CERTIFICATE = OpenSSL::X509::Certificate.new(File.read(File.expand_path('certificate.pem', __dir__)))

if GOOGLE_X509_CERTIFICATE.not_after <= Time.now
  raise "Test certificate is expired. Generate a new one and run the tests again: `bundle exec rake test:certificate:generate`."
end

require 'google-id-token'
GoogleSignIn::Identity.validator = GoogleIDToken::Validator.new(x509_cert: GOOGLE_X509_CERTIFICATE)

class ActionView::TestCase
  private
    def assert_dom_equal(expected, actual, message = nil)
      super expected.remove(/(\A|\n)\s*/), actual, message
    end
end
