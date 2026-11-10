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
end
