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

      context "when filtering by mood" do
        def active_chip
          response.body[%r{<a [^>]*aria-current="page"[^>]*>\s*([^<]+?)\s*</a>}, 1]
        end

        it "lists only the cocktails with that mood" do
          get cocktails_path(mood: "golden_sunset")

          expect(response.body).to include("Margarita")
          expect(response.body).not_to include("Negroni")
          expect(active_chip).to eq("Golden Sunset")
        end

        it "lists every cocktail for an unknown mood" do
          get cocktails_path(mood: "grumpy")

          expect(response.body).to include("Negroni", "Margarita")
          expect(active_chip).to eq("All")
        end

        it "marks All as active without a filter" do
          get cocktails_path
          expect(active_chip).to eq("All")
        end

        it "shows the mood on each card" do
          get cocktails_path
          expect(response.body).to include('cocktail-card__mood">Golden Sunset')
        end

        it "shows a station-empty message, not the general one, for a mood with no cocktails" do
          get cocktails_path(mood: "heartbreak")

          expect(response.body).to include("Nothing on this station yet.", "Heartbreak? Nobody", "hosts/reina/surprise")
          expect(response.body).not_to include("No cocktails yet.")
        end

        it "hides the tuner when there are no cocktails at all" do
          Cocktail.delete_all

          get cocktails_path

          expect(response.body).to include("No cocktails yet.")
          expect(response.body).not_to include("mood-tuner")
        end
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
        { cocktail: { name: "Mojito", ingredients: "Rum, mint, lime", instructions: "Muddle and stir.", difficulty: "medium", mood: "summer_night" } }
      end

      it "creates a cocktail owned by the current user" do
        expect {
          post cocktails_path, params: valid_params
        }.to change(Cocktail, :count).by(1)

        cocktail = Cocktail.last
        expect(cocktail.user).to eq(users(:one))
        expect(cocktail).to be_medium
        expect(cocktail).to be_summer_night
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

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Name can&#39;t be blank")
      end

      it "re-renders the form when difficulty is unknown" do
        post cocktails_path, params: { cocktail: valid_params[:cocktail].merge(difficulty: "bogus") }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Difficulty is not included in the list")
      end
    end

    describe "GET /cocktails/:id/edit" do
      it "renders the form for an own cocktail" do
        get edit_cocktail_path(cocktail)
        expect(response).to have_http_status(:success)
      end

      it "returns not found for another user's cocktail" do
        get edit_cocktail_path(cocktails(:two))
        expect(response).to have_http_status(:not_found)
      end
    end

    describe "PATCH /cocktails/:id" do
      it "updates an own cocktail" do
        patch cocktail_path(cocktail), params: { cocktail: { name: "Boulevardier", difficulty: "hard" } }

        expect(cocktail.reload.name).to eq("Boulevardier")
        expect(cocktail).to be_hard
        expect(response).to redirect_to(cocktail_path(cocktail))
      end

      it "re-renders the form with errors when invalid" do
        patch cocktail_path(cocktail), params: { cocktail: { name: "" } }

        expect(cocktail.reload.name).to eq("Negroni")
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "does not update another user's cocktail" do
        other = cocktails(:two)

        patch cocktail_path(other), params: { cocktail: { name: "Hacked" } }

        expect(response).to have_http_status(:not_found)
        expect(other.reload.name).to eq("Margarita")
      end
    end

    describe "DELETE /cocktails/:id" do
      it "deletes an own cocktail" do
        expect {
          delete cocktail_path(cocktail)
        }.to change(Cocktail, :count).by(-1)

        expect(response).to redirect_to(cocktails_path)
        expect(response).to have_http_status(:see_other)
      end

      it "does not delete another user's cocktail" do
        expect {
          delete cocktail_path(cocktails(:two))
        }.not_to change(Cocktail, :count)

        expect(response).to have_http_status(:not_found)
      end
    end

    describe "edit link on the show page" do
      it "is shown to the owner" do
        get cocktail_path(cocktail)
        expect(response.body).to include(edit_cocktail_path(cocktail))
      end

      it "is hidden from other users" do
        get cocktail_path(cocktails(:two))
        expect(response.body).not_to include(edit_cocktail_path(cocktails(:two)))
      end
    end
  end
end
