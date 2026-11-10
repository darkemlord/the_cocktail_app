require "rails_helper"

RSpec.describe User, type: :model do
  it "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    expect(user.email_address).to eq("downcased@example.com")
  end

  it "is valid with an email and a long enough password" do
    expect(User.new(email_address: "new@example.com", password: "password")).to be_valid
  end

  it "requires a well formed email_address" do
    user = User.new(email_address: "not-an-email", password: "password")

    expect(user).not_to be_valid
    expect(user.errors).to include(:email_address)
  end

  it "requires a unique email_address ignoring case" do
    user = User.new(email_address: "ONE@example.com", password: "password")

    expect(user).not_to be_valid
    expect(user.errors).to include(:email_address)
  end

  it "requires a password of at least 8 characters" do
    user = User.new(email_address: "new@example.com", password: "short")

    expect(user).not_to be_valid
    expect(user.errors).to include(:password)
  end

  it "can be updated without changing the password" do
    user = users(:one)
    expect(user.update(email_address: "renamed@example.com")).to be(true)
  end
end
