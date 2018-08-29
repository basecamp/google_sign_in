require 'google-id-token'
require 'active_support/core_ext/class/attribute'

module GoogleSignIn
  class Identity
    class_attribute :validator
    self.validator = GoogleIDToken::Validator.new

    class_attribute :logger
    self.logger = Logger.new(STDOUT)

    def initialize(token)
      ensure_client_id_present
      set_extracted_payload(token)
      ensure_proper_audience
    end

    def user_id
      @payload["sub"]
    end

    def name
      @payload["name"]
    end

    def email_address
      @payload["email"]
    end

    def email_verified?
      @payload["email_verified"] == "true"
    end

    def avatar_url
      @payload["picture"]
    end

    def locale
      @payload["locale"]
    end

    private
      def ensure_client_id_present
        if client_id.blank?
          raise ArgumentError, "GoogleSignIn.client_id must be set to validate identity"
        end
      end

      def set_extracted_payload(token)
        @payload = validator.check(token, client_id)
      rescue GoogleIDToken::ValidationError => e
        logger.error "Google token failed to validate (#{e.message})"
        @payload = {}
      end

      def ensure_proper_audience
        unless @payload["aud"].include?(client_id)
          raise "Failed to locate the client_id #{client_id} in the authorized audience (#{@payload["aud"]})"
        end
      end

      def client_id
        GoogleSignIn.client_id
      end
  end
end
