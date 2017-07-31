require 'google_sign_in/identity'

module GoogleSignIn
  module Helper
    def google_sign_in(url:, &block)
      content_for :head,
        google_sign_in_javacript_include_tag +
        google_sign_in_client_id_meta_tag

      google_sign_in_javascript_tag +
      google_sign_in_hidden_form_tag(url: url) +
      google_sign_in_click_handler(&block)
    end

    private
      HIDDEN_INPUT_ID = "google_sign_in_token"
      SUBMIT_BUTTON_ID = "google_sign_in_submit"
      CONTAINER_ID = "google_sign_in_container"

      def google_sign_in_javacript_include_tag
        javascript_include_tag "https://apis.google.com/js/api.js", async: true, defer: true,
          onload: "this.onload=function(){};setupGoogleSignIn()",
          onreadystatechange: "if (this.readyState === 'complete') this.onload()",
          data: { turbolinks_track: :reload, force_turbolinks_reload: Time.now.to_i }
      end

      def google_sign_in_client_id_meta_tag
        tag.meta name: "google-signin-client_id", content: GoogleSignIn::Identity.client_id
      end

      def google_sign_in_hidden_form_tag(url:)
        form_with url: url, html: { style: "display: none" } do |form|
          form.hidden_field(:google_id_token, id: HIDDEN_INPUT_ID) + form.submit(id: SUBMIT_BUTTON_ID)
        end
      end

      def google_sign_in_click_handler(&block)
        tag.div(id: CONTAINER_ID, style: "visibility: hidden") { capture(&block) }
      end

      def google_sign_in_javascript_tag
        javascript_tag <<-JS.strip_heredoc
          (function() {
            function installAuthClient(callback) {
              gapi.load("client:auth2", function() {
                gapi.auth2.init().then(callback)
              })
            }

            function installClickHandler() {
              var element = document.getElementById("#{CONTAINER_ID}")
              var options = new gapi.auth2.SigninOptionsBuilder()
              options.setPrompt("select_account")
              gapi.auth2.getAuthInstance().attachClickHandler(element, options, handleSignIn)
              element.style.visibility = "visible"
            }

            function handleSignIn(googleUser) {
              var token = googleUser.getAuthResponse().id_token
              if (token) {
                document.getElementById("#{HIDDEN_INPUT_ID}").value = token
                document.getElementById("#{SUBMIT_BUTTON_ID}").click()
                gapi.auth2.getAuthInstance().signOut()
              }
            }

            window.setupGoogleSignIn = function() {
              installAuthClient(installClickHandler)
            }
          })()
        JS
      end
  end
end
