require "rails_helper"

RSpec.describe Cocktail, type: :model do
  it "is valid with a user, name, ingredients and instructions" do
    expect(cocktails(:one)).to be_valid
  end

  it "requires name, ingredients and instructions" do
    cocktail = Cocktail.new(user: users(:one))

    expect(cocktail).not_to be_valid
    expect(cocktail.errors).to include(:name, :ingredients, :instructions)
  end

  it "defaults difficulty to easy" do
    expect(Cocktail.new).to be_easy
  end
end
