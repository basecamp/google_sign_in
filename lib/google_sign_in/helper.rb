module GoogleSignIn
  module Helper
    def google_sign_in_button(text = nil, proceed_to:, **options, &block)
      form_with url: google_sign_in.authorization_path do
        hidden_field_tag(:proceed_to, proceed_to) + button_tag(name: nil, text: text, **options, &block)
      end
    end
  end
end
