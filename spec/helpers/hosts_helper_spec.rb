require "rails_helper"

RSpec.describe HostsHelper, type: :helper do
  describe "#host_dialogue" do
    it "renders the host with their expression and line" do
      html = helper.host_dialogue(:reina, :curious, "What are we mixing tonight?")

      expect(html).to include("host-reina", "The Bartender", "hosts/reina/curious", "What are we mixing tonight?")
    end

    it "adds the end modifier when placed at the end" do
      html = helper.host_dialogue(:mika, :smile, "Cheers!", placement: :end)
      expect(html).to include("dialogue--end")
    end

    it "rejects an unknown host" do
      expect { helper.host_dialogue(:bob, :smile, "Hi") }.to raise_error(ArgumentError, /Unknown host/)
    end

    it "rejects an unknown expression" do
      expect { helper.host_dialogue(:mika, :angry, "Hi") }.to raise_error(ArgumentError, /Unknown expression/)
    end
  end

  describe "#recipe_host_dialogue" do
    it "has a host for every mood" do
      Cocktail.moods.each_key do |mood|
        expect(helper.recipe_host_dialogue(Cocktail.new(mood: mood))).to include("dialogue--end")
      end
    end

    it "sends Nagisa to elegant moods" do
      expect(helper.recipe_host_dialogue(Cocktail.new(mood: :midnight_romance))).to include("host-nagisa")
    end

    it "sends Mika to tropical moods" do
      expect(helper.recipe_host_dialogue(Cocktail.new(mood: :summer_night))).to include("host-mika", "summer vacation")
    end

    it "sends Reina to neon moods" do
      expect(helper.recipe_host_dialogue(Cocktail.new(mood: :neon_dreams))).to include("host-reina")
    end

    it "sends Reina to hard recipes whatever the mood" do
      html = helper.recipe_host_dialogue(Cocktail.new(mood: :summer_night, difficulty: :hard))
      expect(html).to include("host-reina", "hurricane")
    end
  end
end
