Gem::Specification.new do |s|
  s.name     = 'google_sign_in'
  s.version  = '0.1.4'
  s.authors  = 'David Heinemeier Hansson'
  s.email    = 'david@basecamp.com'
  s.summary  = 'Sign in (or up) with Google for Rails applications'
  s.homepage = 'https://github.com/basecamp/google_sign_in'
  s.license  = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'rails', '>= 5.1.0'
  s.add_dependency 'google-id-token', '>= 1.4.0'
  s.add_dependency 'oauth2', '>= 1.4.0'

  s.add_development_dependency 'bundler', '~> 1.15'
  s.add_development_dependency 'webmock'

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
