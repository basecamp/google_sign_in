# Google Sign-In for Rails

Google Sign-In provides an easy and secure way to let users signin into and up for your service,
without adding yet-another per-app email/password combination. Integrating it into your Rails app
should be drop-in easy. This gem makes it so.

The only configuration needed is setting the Google client id for your application. [Google has a
tutorial on how to setup a client id](https://developers.google.com/identity/sign-in/web/server-side-flow#step_1_create_a_client_id_and_client_secret).

Once you have your client id, create a `config/initializers/google_sign_in_client_id.rb` file with this:
`GoogleSignIn::Identity.client_id = <THAT CLIENT ID YOU GOT FROM GOOGLE>`

Now you can use the sign-in integration on your signup or sigin screen.

## Example

Here's the most basic example:

```ruby
# app/views/layouts/application.html.erb
<html>
<head>
<% # Required for google_sign_in to add the Google JS assets and meta tags! %>
<%= yield :head %>
</head>
<body>
<%= yield %>
</body>
</html>

# app/views/sessions/new.html.erb
<%= google_sign_in(url: session_path) do %>
  # You can replace this with whatever design you please for the button.
  # You should follow Google's brand guidelines for Google Sign-In, though:
  # https://developers.google.com/identity/branding-guidelines
  <%= button_tag("Signin with Google") %>
<% end %>
```

The `url` option is the URL that the hidden form will be submitted against along with the Google ID Token
that's set after the user has picked the account and authenticated in the pop-up window Google provides.

You can then use that in a sessions controller like so:

```ruby
class SessionsController < ApplicationController
  def new
  end

  def create
    if user = authenticate_via_google
      cookies.signed[:user_id] = user.id
      redirect_to user
    else
      redirect_to new_session_url, alert: "authentication_failed"
    end
  end

  private
    def authenticate_via_google
      if params[:google_id_token].present?
        User.find_by google_id: GoogleSignIn::Identity.new(params[:google_id_token]).user_id
      end
    end
end
```

(This example assumes that a user has already signed up for your service using Google Sign-In and that
you're storing the Google user id in the `User#google_id` attribute).

That's it! You can checkout the `GoogleSignIn::Identity` class for the thin wrapping it provides around
the decoding of the Google ID Token using the google-id-token library. Interrogating this identity object
for profile details is particularly helpful when you use Google for signup, as you can get the name, email
address, avatar url, and locale through it.

## Outstanding work

- Proper testing. Need to generate a test client_id/google id token combo that we can use to test with.
- Not much more. I'm seeking to keep this simple, just for signin/signup, not general Google integration.

## License

Google Sign-In for Rails is released under the [MIT License](https://opensource.org/licenses/MIT).
