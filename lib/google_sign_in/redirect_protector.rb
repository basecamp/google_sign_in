require 'uri'

module GoogleSignIn
  module RedirectProtector
    extend self

    class Violation < StandardError; end

    QUALIFIED_URL_PATTERN = /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

    def ensure_same_origin(target, source)
      if (target =~ QUALIFIED_URL_PATTERN && origin_of(target) == origin_of(source)) ||
         (target =~ URI::DEFAULT_PARSER.regexp[:ABS_PATH] && URI(target).host.nil? && !target.start_with?("//"))
        return
      end

      raise Violation, "Redirect target #{target.inspect} does not have same origin as request (expected #{origin_of(source)})"
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
