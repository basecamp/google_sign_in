ENV['RAILS_ENV'] = 'test'

FAKE_GOOGLE_CLIENT_ID = '86179201039-eks5VfVc46WoFYyZVUDpQHeZFDRCqno3.apps.googleusercontent.com'
FAKE_GOOGLE_CLIENT_SECRET = 'r(XsBajmyMddruvf$jDgLyPK'

require_relative '../test/dummy/config/environment'

require 'rails/test_help'
require 'webmock/minitest'
require 'byebug'
