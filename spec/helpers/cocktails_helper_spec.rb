require "rails_helper"

RSpec.describe CocktailsHelper, type: :helper do
  describe "#cocktail_tone" do
    it "has a tone for every mood" do
      Cocktail.moods.each_key do |mood|
        expect(helper.cocktail_tone(Cocktail.new(mood: mood))).to include(:n, :tag, :glass)
      end
    end

    it "picks the cover from the mood" do
      expect(helper.cocktail_tone(Cocktail.new(mood: :summer_night))[:glass]).to eq("highball")
      expect(helper.cocktail_tone(Cocktail.new(mood: :neon_dreams))[:glass]).to eq("margarita")
    end
  end

  describe "#mood_options" do
    it "lists every mood with a readable label" do
      expect(helper.mood_options).to include([ "Summer Night", "summer_night" ], [ "Tokyo Rain", "tokyo_rain" ])
      expect(helper.mood_options.size).to eq(Cocktail.moods.size)
    end
  end

  describe "#ingredient_lines" do
    it "splits ingredients by line and drops blank ones" do
      cocktail = Cocktail.new(ingredients: "30 ml gin\n\n  Orange peel  \n")
      expect(helper.ingredient_lines(cocktail)).to eq([ "30 ml gin", "Orange peel" ])
    end
  end
end
