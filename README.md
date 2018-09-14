# Google Sign-In for Rails

This gem allows you to add Google sign-in to your Rails app. You can let users sign up for and sign in to your service
with their Google accounts.


## Installation

Add `google_sign_in` to your Rails app’s Gemfile and run `bundle install`:

```ruby
gem 'google_sign_in'
```

Google Sign-In for Rails requires Rails 5.2 or newer.


## Configuration

First, set up an OAuth 2.0 Client ID in the Google API Console:

1. Go to the [API Console](https://console.developers.google.com/apis/credentials).

2. In the projects menu at the top of the page, ensure the correct project is selected or create a new one.

3. In the left-side navigation menu, choose APIs & Services → Credentials.

4. Click the button labeled “Create credentials.” In the menu that appears, choose to create an **OAuth client ID**.

5. When prompted to select an application type, select **Web application**.

6. Enter your application’s name.

7. This gem adds a single OAuth callback to your app at `/google_sign_in/callback`. Under **Authorized redirect URIs**,
   add that callback for your application’s domain: for example, `https://example.com/google_sign_in/callback`.

   To use Google sign-in in development, you’ll need to add another redirect URI for your local environment, like
   `http://localhost:3000/google_sign_in/callback`. For security reasons, we recommend using a separate
   client ID for local development. Repeat these instructions to set up a new client ID for development.

8. Click the button labeled “Create.” You’ll be presented with a client ID and client secret. Save these.

With your client ID set up, configure your Rails application to use it. Run `bin/rails credentials:edit` to edit your
app’s [encrypted credentials](https://guides.rubyonrails.org/security.html#custom-credentials) and add the following:

```yaml
google_sign_in:
  client_id: [Your client ID here]
  client_secret: [Your client secret here]
```

You’re all set to use Google sign-in now. The gem automatically uses the client ID and client secret in your credentials.

Alternatively, you can provide the client ID and client secret using ENV variables. Add a new initializer that sets
`config.google_sign_in.client_id` and `config.google_sign_in.client_secret`:

```ruby
# config/initializers/google_sign_in.rb
Rails.application.configure do
  config.google_sign_in.client_id     = ENV['google_sign_in_client_id']
  config.google_sign_in.client_secret = ENV['google_sign_in_client_secret']
end
```

**⚠️ Important:** Take care to protect your client secret from disclosure to third parties.


## Usage

This gem provides a `google_sign_in_button` helper. It generates a button which initiates Google sign-in:

```erb
<%= google_sign_in_button 'Sign in with my Google account', proceed_to: create_login_url %>

<%= google_sign_in_button image_tag('google_logo.png', alt: 'Google'), proceed_to: create_login_url %>

<%= google_sign_in_button proceed_to: create_login_url do %>
  Sign in with my <%= image_tag('google_logo.png', alt: 'Google') %> account
<% end %>
```

The `proceed_to` argument is required. After authenticating with Google, the gem redirects to `proceed_to`, providing
a Google ID token in `flash[:google_sign_in_token]`. Your application decides what to do with it:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ...
  get 'login', to: 'logins#new'
  get 'login/create', to: 'logins#create', as: :create_login
end
```

```ruby
# app/controllers/logins_controller.rb
class LoginsController < ApplicationController
  def new
  end

  def create
    if user = authenticate_with_google
      cookies.signed[:user_id] = user.id
      redirect_to user
    else
      redirect_to new_session_url, alert: 'authentication_failed'
    end
  end

  private
    def authenticate_with_google
      if flash[:google_sign_in_token].present?
        User.find_by google_id: GoogleSignIn::Identity.new(flash[:google_sign_in_token]).user_id
      end
    end
end
```

(The above example assumes the user has already signed up for your service and that you’re storing their Google user ID
in the `User#google_id` attribute.)

For security reasons, the `proceed_to` URL you provide to `google_sign_in_button` is required to reside on the same
origin as your application. This means it must have the same protocol, host, and port as the page where
`google_sign_in_button` is used. We enforce this before redirecting to the `proceed_to` URL to guard against
[open redirects](https://www.owasp.org/index.php/Unvalidated_Redirects_and_Forwards_Cheat_Sheet).

The `GoogleSignIn::Identity` class decodes and verifies the integrity of a Google ID token. It exposes the profile
information contained in the token via the following instance methods:

* `name`

* `email_address`

* `user_id`: A value that uniquely identifies a single Google user. Use this, not `email_address`, to associate a
  Google user with an application user. A Google user’s email address may change, but their `user_id` will remain constant.

* `email_verified?`

* `avatar_url`

* `locale`

* `hd`: The hosted G Suite domain of the user, provided only if user belongs to a hosted domain.

## Security

For information on our security response procedure, see [SECURITY.md](SECURITY.md).


## License

Google Sign-In for Rails is released under the [MIT License](https://opensource.org/licenses/MIT).

Google is a registered trademark of Google LLC. This project is not operated by or in any way affiliated with Google LLC.
