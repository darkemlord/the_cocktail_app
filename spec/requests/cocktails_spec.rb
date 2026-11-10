require "rails_helper"

RSpec.describe "Cocktails", type: :request do
  let(:cocktail) { cocktails(:one) }

  context "when not authenticated" do
    it "redirects index to login" do
      get cocktails_path
      expect(response).to redirect_to(new_session_path)
    end

    it "redirects show to login" do
      get cocktail_path(cocktail)
      expect(response).to redirect_to(new_session_path)
    end
  end

  context "when authenticated" do
    before { sign_in_as(users(:one)) }

    describe "GET /cocktails" do
      it "lists cocktails from every user" do
        get cocktails_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Negroni", "Margarita")
      end

      it "is the root page" do
        get root_path
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET /cocktails/:id" do
      it "shows the cocktail" do
        get cocktail_path(cocktail)

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Negroni", "Campari", "one@example.com")
      end

      it "returns not found for a missing cocktail" do
        get cocktail_path(id: 0)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
