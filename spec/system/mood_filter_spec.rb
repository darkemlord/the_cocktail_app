require "rails_helper"

RSpec.describe "Filtering cocktails by mood", type: :system do
  let(:user) { users(:one) }

  before do
    # Enough cards that the page scrolls well past the dial
    12.times do |i|
      user.cocktails.create!(name: "Sunset #{i}", ingredients: "Rum", instructions: "Shake.",
        difficulty: :easy, mood: :golden_sunset)
    end

    sign_in_through_form(user)
  end

  it "keeps the scroll position and focus when a station is clicked" do
    visit cocktails_path(mood: "golden_sunset")
    page.execute_script("document.querySelector('.mood-tuner').scrollIntoView()")
    scroll_before = page.evaluate_script("window.scrollY")
    expect(scroll_before).to be > 0

    find(".mood-tuner__station", text: "All").click

    expect(page).to have_css(".mood-tuner__station[aria-current='page']", text: "All")
    expect(page).to have_text("Negroni")
    expect(page.evaluate_script("window.scrollY")).to eq(scroll_before)
    expect(page.evaluate_script("document.activeElement.textContent.trim()")).to eq("All")
  end
end
