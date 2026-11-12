module SystemSessionHelper
  # Signs in through the real form; fixture users share the password "password"
  def sign_in_through_form(user)
    visit new_session_path
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"
    expect(page).to have_button("Log out")
  end
end

# System specs run a real browser against a test server.
# In Docker the browser is the `chrome` service, so the server has to listen on
# every interface and Chrome reaches it at this container's IP.
# Icon-only buttons (like the dialogue ×) are named by aria-label, so find them by it
Capybara.enable_aria_label = true

RSpec.configure do |config|
  config.include SystemSessionHelper, type: :system

  config.before(:each, type: :system) do
    if ENV["SELENIUM_URL"]
      Capybara.server_host = "0.0.0.0"
      Capybara.server_port = 3001
      Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:3001"

      driven_by :selenium, using: :headless_chrome, screen_size: [ 1280, 800 ],
        options: { browser: :remote, url: ENV["SELENIUM_URL"] }
    else
      driven_by :selenium, using: :headless_chrome, screen_size: [ 1280, 800 ]
    end
  end
end
