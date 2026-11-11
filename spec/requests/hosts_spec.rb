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

  describe "hiding the hosts" do
    it "shows them by default with a hide toggle" do
      get new_session_path

      expect(response.body).not_to include('class="app app--hosts-off"')
      expect(response.body).to include("Hide hosts")
    end

    it "renders the page with hosts hidden when the cookie is set" do
      cookies["hosts_off"] = "1"

      get new_session_path

      expect(response.body).to include('class="app app--hosts-off"')
      expect(response.body).to match(%r{data-hosts-target="toggle"[^>]*>\s*Show hosts})
    end

    # The label already names the action, so aria-pressed would contradict it
    # ("Show hosts, pressed") for screen readers.
    it "labels the toggle with its action and no pressed state" do
      get new_session_path
      expect(response.body).not_to include("aria-pressed")
    end
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

    it "shows Nagisa on an after hours cocktail" do
      get cocktail_path(cocktails(:one))
      expect(host_on_page).to eq("nagisa")
    end

    it "shows Mika on a tropical cocktail" do
      cocktails(:one).update!(mood: :summer_night)

      get cocktail_path(cocktails(:one))

      expect(host_on_page).to eq("mika")
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
