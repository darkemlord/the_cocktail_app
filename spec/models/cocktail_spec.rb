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

  it "defaults mood to after_hours" do
    expect(Cocktail.new).to be_after_hours
  end

  it "is invalid with an unknown mood" do
    cocktail = cocktails(:one)
    cocktail.mood = "grumpy"

    expect(cocktail).not_to be_valid
    expect(cocktail.errors).to include(:mood)
  end

  it "is invalid with an unknown difficulty" do
    cocktail = cocktails(:one)
    cocktail.difficulty = "bogus"

    expect(cocktail).not_to be_valid
    expect(cocktail.errors).to include(:difficulty)
  end

  describe ".by_mood" do
    it "keeps only the cocktails with that mood" do
      expect(Cocktail.by_mood("golden_sunset")).to contain_exactly(cocktails(:two))
    end

    it "returns every cocktail for an unknown mood" do
      expect(Cocktail.by_mood("grumpy")).to contain_exactly(cocktails(:one), cocktails(:two))
    end

    it "returns every cocktail without a mood" do
      expect(Cocktail.by_mood(nil)).to contain_exactly(cocktails(:one), cocktails(:two))
    end
  end
end
