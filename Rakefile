require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = FileList["test/**/*_test.rb"]
  test.warning = false
end

task default: :test

desc "Generates an X509 certificate for decoding test ID tokens"
task "test:certificate:generate" do
  require "openssl"
  require "active_support"
  require "active_support/core_ext/integer/time"

  key = OpenSSL::PKey::RSA.new(File.read(File.expand_path("test/key.pem", __dir__)))

  certificate = OpenSSL::X509::Certificate.new
  certificate.subject = certificate.issuer = OpenSSL::X509::Name.parse("/CN=google-sign-in-for-rails.example.com")
  certificate.not_before = Time.now
  certificate.not_after = 5.years.from_now
  certificate.public_key = key.public_key
  certificate.serial = 0
  certificate.version = 1

  extension_factory = OpenSSL::X509::ExtensionFactory.new
  extension_factory.subject_certificate = certificate
  extension_factory.issuer_certificate = certificate
  certificate.extensions = [
    extension_factory.create_extension("basicConstraints", "CA:FALSE", true),
    extension_factory.create_extension("keyUsage", "digitalSignature", true),
    extension_factory.create_extension("extendedKeyUsage", "clientAuth", true)
  ]

  certificate.sign(key, OpenSSL::Digest::SHA1.new)
  File.write(File.expand_path("test/certificate.pem", __dir__), certificate.to_pem)
end
