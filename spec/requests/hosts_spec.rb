require "rails_helper"

RSpec.describe "Hosts", type: :request do
  def host_on_page
    response.body[/class="dialogue host-(\w+)/, 1]
  end

  it "shows Nagisa on the login page" do
    get new_session_path
    expect(host_on_page).to eq("nagisa")
  end

  it "shows Mika on the sign up page" do
    get new_registration_path
    expect(host_on_page).to eq("mika")
  end

  context "when authenticated" do
    before { sign_in_as(users(:one)) }

    it "shows Reina on the cocktails list" do
      get cocktails_path
      expect(host_on_page).to eq("reina")
    end

    it "shows Mika when the list is empty" do
      Cocktail.delete_all

      get cocktails_path

      expect(host_on_page).to eq("mika")
    end

    it "shows Reina on a hard cocktail" do
      cocktails(:one).update!(difficulty: :hard)

      get cocktail_path(cocktails(:one))

      expect(host_on_page).to eq("reina")
    end

    it "shows Nagisa on any other cocktail" do
      get cocktail_path(cocktails(:one))
      expect(host_on_page).to eq("nagisa")
    end

    it "shows Mika celebrating right after creating a cocktail" do
      post cocktails_path, params: { cocktail: { name: "Mojito", ingredients: "Rum", instructions: "Stir." } }
      follow_redirect!

      expect(host_on_page).to eq("mika")
      expect(response.body).to include("Cheers!")
    end

    it "shows a surprised Reina when the form has errors" do
      post cocktails_path, params: { cocktail: { name: "" } }

      expect(host_on_page).to eq("reina")
      expect(response.body).to include("hosts/reina/surprise")
    end
  end
end
