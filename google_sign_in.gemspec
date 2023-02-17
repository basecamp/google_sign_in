Gem::Specification.new do |s|
  s.name     = 'google_sign_in'
  s.version  = '1.3.0'
  s.authors  = ['David Heinemeier Hansson', 'George Claghorn']
  s.email    = ['david@basecamp.com', 'george@basecamp.com']
  s.summary  = 'Sign in (or up) with Google for Rails applications'
  s.homepage = 'https://github.com/basecamp/google_sign_in'
  s.license  = 'MIT'

  s.required_ruby_version = '>= 2.5.0'

  s.add_dependency 'rails', '>= 6.1.0'
  s.add_dependency 'google-id-token', '>= 1.4.0'
  s.add_dependency 'oauth2', '>= 1.4.0'

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
