require 'uri'

module GoogleSignIn
  module RedirectProtector
    extend self

    class Violation < StandardError; end

    QUALIFIED_URL_PATTERN = /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

    def ensure_same_origin(target, source)
      if target.blank? || (target =~ QUALIFIED_URL_PATTERN && origin_of(target) != origin_of(source))
        raise Violation, "Redirect target #{target.inspect} does not have same origin as request (expected #{origin_of(source)})"
      end
    end

    private
      def origin_of(url)
        uri = URI(url)
        "#{uri.scheme}://#{uri.host}:#{uri.port}"
      rescue ArgumentError
        nil
      end
  end
end
