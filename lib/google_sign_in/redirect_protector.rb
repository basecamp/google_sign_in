require 'uri'

module GoogleSignIn
  module RedirectProtector
    extend self

    class Violation < StandardError; end

    QUALIFIED_URL_PATTERN = /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

    def ensure_same_origin(target, source)
      if target =~ QUALIFIED_URL_PATTERN && origin_of(target) != origin_of(source)
        raise Violation, "Redirect target #{target} does not have same origin as request (#{source})"
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
