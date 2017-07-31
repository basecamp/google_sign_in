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
          form.hidden_field(:google_id_token, id: "google_sign_in_token") + form.submit(id: "google_sign_in_submit")
        end
      end

      def google_sign_in_click_handler(&block)
        tag.div(id: "google_sign_in_container", style: "visibility: hidden") { capture(&block) }
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
              var element = document.getElementById("google_sign_in_container")
              var options = new gapi.auth2.SigninOptionsBuilder()
              options.setPrompt("select_account")
              gapi.auth2.getAuthInstance().attachClickHandler(element, options, handleSignIn)
              element.style.visibility = "visible"
            }

            function handleSignIn(googleUser) {
              var token = googleUser.getAuthResponse().id_token
              if (token) {
                document.getElementById("google_sign_in_token").value = token
                document.getElementById("google_sign_in_submit").click()
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
