Gem::Specification.new do |s|
  s.name     = 'google_sign_in'
  s.version  = '1.2.1'
  s.authors  = ['David Heinemeier Hansson', 'George Claghorn']
  s.email    = ['david@basecamp.com', 'george@basecamp.com']
  s.summary  = 'Sign in (or up) with Google for Rails applications'
  s.homepage = 'https://github.com/basecamp/google_sign_in'
  s.license  = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'rails', '>= 5.2.0'
  s.add_dependency 'google-id-token', '>= 1.4.0'
  s.add_dependency 'oauth2', '>= 1.4.0'

  s.add_development_dependency 'bundler', '~> 1.15'
  s.add_development_dependency 'jwt', '>= 1.5.6'
  s.add_development_dependency 'webmock', '>= 3.4.2'

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
