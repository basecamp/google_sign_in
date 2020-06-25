require "test_helper"

class GoogleSignIn::ButtonHelperTest < ActionView::TestCase
  test "generating a login button with text content" do
    assert_dom_equal <<-HTML, google_sign_in_button("Log in with Google", proceed_to: "https://www.example.com/login")
      <form action="/google_sign_in/authorization" accept-charset="UTF-8" method="post">
        <input name="proceed_to" type="hidden" value="https://www.example.com/login" />
        <button type="submit">Log in with Google</button>
      </form>
    HTML
  end

  test "generating a login button with HTML content" do
    assert_dom_equal <<-HTML, google_sign_in_button(proceed_to: "https://www.example.com/login") { image_tag("google.png") }
      <form action="/google_sign_in/authorization" accept-charset="UTF-8" method="post">
        <input name="proceed_to" type="hidden" value="https://www.example.com/login" />
        <button type="submit"><img src="/images/google.png"></button>
      </form>
    HTML
  end

  test "generating a login button with custom attributes" do
    button = google_sign_in_button("Log in with Google", proceed_to: "https://www.example.com/login",
      class: "login-button", data: { disable_with: "Loading Google login…" })

    assert_dom_equal <<-HTML, button
      <form action="/google_sign_in/authorization" accept-charset="UTF-8" method="post">
        <input name="proceed_to" type="hidden" value="https://www.example.com/login" />
        <button type="submit" class="login-button" data-disable-with="Loading Google login…">Log in with Google</button>
      </form>
    HTML
  end
end
