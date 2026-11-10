require "rails_helper"

RSpec.describe "Registrations", type: :request do
  let(:valid_params) do
    { user: { email_address: "new@example.com", password: "password", password_confirmation: "password" } }
  end

  it "renders the sign up form" do
    get new_registration_path
    expect(response).to have_http_status(:success)
  end

  it "creates the user and logs them in" do
    expect {
      post registration_path, params: valid_params
    }.to change(User, :count).by(1)

    expect(response).to redirect_to(root_path)
    expect(cookies[:session_id]).to be_present

    follow_redirect!
    expect(response.body).to include("new@example.com")
  end

  it "re-renders the form when passwords do not match" do
    expect {
      post registration_path, params: { user: valid_params[:user].merge(password_confirmation: "different") }
    }.not_to change(User, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Password confirmation doesn&#39;t match")
  end

  it "re-renders the form when the email is taken" do
    expect {
      post registration_path, params: { user: valid_params[:user].merge(email_address: "one@example.com") }
    }.not_to change(User, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Email address has already been taken")
  end
end
