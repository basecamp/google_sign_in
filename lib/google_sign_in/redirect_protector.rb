require 'uri'

module GoogleSignIn
  module RedirectProtector
    extend self

    class Violation < StandardError; end

    QUALIFIED_URL_PATTERN = /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

    def ensure_same_origin(target, source)
      unless uri_same_origin?(target, source) || absolute_path?(target)
        raise Violation, "Redirect target #{target.inspect} does not have same origin as request #{source.inspect}"
      end
    end

    private
      def uri_same_origin?(target, source)
        target =~ QUALIFIED_URL_PATTERN && origin_of(target) == origin_of(source)
      rescue ArgumentError, URI::Error
        false
      end

      def absolute_path?(target)
        target =~ URI::DEFAULT_PARSER.regexp[:ABS_PATH] && URI(target).host.nil? && !target.start_with?("//")
      rescue ArgumentError, URI::Error
        false
      end

      def origin_of(url)
        uri = URI(url)
        "#{uri.scheme}://#{uri.host}:#{uri.port}"
      end
  end
end
