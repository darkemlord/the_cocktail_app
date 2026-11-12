require "rails_helper"

# Going Back makes Turbo restore a cached <body>, which may not match what
# happened after it was cached. These cover what that snapshot should look like.
RSpec.describe "Showing and hiding the hosts", type: :system do
  before do
    sign_in_through_form(users(:one))
  end

  it "brings a dialogue closed with × back after leaving and going Back" do
    click_on "Close dialogue"
    expect(page).to have_no_text("What are we mixing tonight?")

    click_on "Negroni"
    expect(page).to have_css("h1", text: "Negroni")
    page.go_back

    expect(page).to have_text("What are we mixing tonight?")
  end

  it "keeps the hosts hidden when they were hidden on a later page" do
    click_on "Negroni"
    expect(page).to have_css("h1", text: "Negroni")
    click_on "Hide hosts", match: :first
    expect(page).to have_css(".dialogue", visible: :hidden)

    page.go_back

    expect(page).to have_css("h1", text: "Cocktails")
    expect(page).to have_no_text("What are we mixing tonight?")
    expect(page).to have_button("Show hosts")
  end
end
