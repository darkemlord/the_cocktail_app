require "rails_helper"

RSpec.describe "Layout", type: :request do
  it "shows the current user and a logout button when authenticated" do
    sign_in_as(users(:one))

    get root_path

    expect(response.body).to include("one@example.com", "Log out")
  end

  it "hides the logout button on the login page" do
    get new_session_path
    expect(response.body).not_to include("Log out")
  end

  it "shows flash messages from any page" do
    sign_in_as(users(:one))

    delete cocktail_path(cocktails(:one))
    follow_redirect!

    expect(response.body).to include("Cocktail was successfully deleted.")
  end
end
