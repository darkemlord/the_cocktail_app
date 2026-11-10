require "rails_helper"

RSpec.describe "Home", type: :request do
  it "redirects to login when not authenticated" do
    get root_path
    expect(response).to redirect_to(new_session_path)
  end

  it "shows the home page when authenticated" do
    sign_in_as(users(:one))

    get root_path

    expect(response).to have_http_status(:success)
    expect(response.body).to include("one@example.com")
  end
end
