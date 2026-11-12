require "rails_helper"

RSpec.describe "Signing in", type: :system do
  it "lands on the cocktail list" do
    sign_in_through_form(users(:one))

    expect(page).to have_css("h1", text: "Cocktails")
    expect(page).to have_text("one@example.com")
  end
end
