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

    describe "GET /cocktails/new" do
      it "renders the form" do
        get new_cocktail_path
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST /cocktails" do
      let(:valid_params) do
        { cocktail: { name: "Mojito", ingredients: "Rum, mint, lime", instructions: "Muddle and stir.", difficulty: "medium" } }
      end

      it "creates a cocktail owned by the current user" do
        expect {
          post cocktails_path, params: valid_params
        }.to change(Cocktail, :count).by(1)

        cocktail = Cocktail.last
        expect(cocktail.user).to eq(users(:one))
        expect(cocktail).to be_medium
        expect(response).to redirect_to(cocktail_path(cocktail))
      end

      it "ignores a user_id sent in the params" do
        post cocktails_path, params: { cocktail: valid_params[:cocktail].merge(user_id: users(:two).id) }
        expect(Cocktail.last.user).to eq(users(:one))
      end

      it "re-renders the form with errors when invalid" do
        expect {
          post cocktails_path, params: { cocktail: { name: "" } }
        }.not_to change(Cocktail, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Name can&#39;t be blank")
      end

      it "re-renders the form when difficulty is unknown" do
        post cocktails_path, params: { cocktail: valid_params[:cocktail].merge(difficulty: "bogus") }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Difficulty is not included in the list")
      end
    end
  end
end
