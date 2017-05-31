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
        javascript_include_tag 'https://apis.google.com/js/platform.js?onload=setupGoogleSignIn', async: true, defer: true
      end

      def google_sign_in_client_id_meta_tag
        tag.meta name: 'google-signin-client_id', content: GoogleSignIn::Identity.client_id
      end

      def google_sign_in_hidden_form_tag(url:)
        form_with url: url, id: 'google_signin', html: { style: 'display: none' } do |form|
          form.hidden_field :google_id_token, id: 'google_id_token'
        end
      end

      def google_sign_in_click_handler(&block)
        tag.div(onclick: 'selectGoogleSignInAccount(event)') { capture(&block) }
      end

      def google_sign_in_javascript_tag
        javascript_tag(<<-EOS
          function setupGoogleSignIn() {
            gapi.load('auth2', function () { gapi.auth2.init() })
          }

          function selectGoogleSignInAccount(event) {
            event.preventDefault()

            options = new gapi.auth2.SigninOptionsBuilder
            options.setPrompt('select_account')

            gapi.auth2.getAuthInstance().signIn(options).then(function (googleUser) {
              var token = googleUser.getAuthResponse().id_token

              if (token !== null) {
                document.getElementById('google_id_token').value = token
                document.getElementById('google_signin').submit()
                gapi.auth2.getAuthInstance().signOut()
              }
            })
          }
  EOS
        )
      end
  end
end
