require 'google-id-token'
require 'active_support/core_ext/module/delegation'

module GoogleSignIn
  class Identity
    class ValidationError < StandardError; end

    class_attribute :validator, default: GoogleIDToken::Validator.new

    def initialize(token)
      ensure_client_id_present
      set_extracted_payload(token)
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
      @payload["email_verified"] == true
    end

    def avatar_url
      @payload["picture"]
    end

    def locale
      @payload["locale"]
    end

    def hd
      @payload["hd"]
    end

    private
      delegate :client_id, to: GoogleSignIn

      def ensure_client_id_present
        if client_id.blank?
          raise ArgumentError, "GoogleSignIn.client_id must be set to validate identity"
        end
      end

      def set_extracted_payload(token)
        @payload = validator.check(token, client_id)
      rescue GoogleIDToken::ValidationError => error
        raise ValidationError, error.message
      end
  end
end
