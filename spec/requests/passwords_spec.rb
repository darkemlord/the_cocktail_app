require "rails_helper"

RSpec.describe "Passwords", type: :request do
  let(:user) { User.take }

  it "renders the reset request form" do
    get new_password_path
    expect(response).to have_http_status(:success)
  end

  it "sends reset instructions to a known user" do
    expect {
      post passwords_path, params: { email_address: user.email_address }
    }.to have_enqueued_mail(PasswordsMailer, :reset).with(user)
    expect(response).to redirect_to(new_session_path)

    follow_redirect!
    expect(response.body).to include("reset instructions sent")
  end

  it "redirects but sends no mail for an unknown user" do
    expect {
      post passwords_path, params: { email_address: "missing-user@example.com" }
    }.not_to have_enqueued_mail
    expect(response).to redirect_to(new_session_path)

    follow_redirect!
    expect(response.body).to include("reset instructions sent")
  end

  it "renders the edit form with a valid token" do
    get edit_password_path(user.password_reset_token)
    expect(response).to have_http_status(:success)
  end

  it "redirects with an invalid token" do
    get edit_password_path("invalid token")
    expect(response).to redirect_to(new_password_path)

    follow_redirect!
    expect(response.body).to include("reset link is invalid")
  end

  it "updates the password" do
    expect {
      put password_path(user.password_reset_token), params: { password: "new-password", password_confirmation: "new-password" }
    }.to change { user.reload.password_digest }
    expect(response).to redirect_to(new_session_path)

    follow_redirect!
    expect(response.body).to include("Password has been reset")
  end

  it "does not update with non matching passwords" do
    expect {
      put password_path(user.password_reset_token), params: { password: "new-password", password_confirmation: "other-password" }
    }.not_to change { user.reload.password_digest }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("match Password")
  end

  it "shows the real error when the password is too short" do
    put password_path(user.password_reset_token), params: { password: "short", password_confirmation: "short" }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("too short")
  end

  it "does not reset or log out everywhere without a password" do
    user.sessions.create!

    expect {
      put password_path(user.password_reset_token)
    }.not_to change { user.reload.password_digest }

    expect(response).to have_http_status(:bad_request)
    expect(user.sessions.count).to eq(1)
  end
end
