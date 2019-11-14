require 'rails_helper'

RSpec.describe User, type: :model do
  context ".create" do
    it "should create new user with password" do
      expect {
        User.create(email: "user1@example.com", password: "password")
      }.to change { User.count }.by(1)

      user = User.find_by(email: "user1@example.com")

      expect(user).not_to be_nil
    end

    it "should not create user without password" do
      user = User.create(email: "user1@example.com")

      expect(user).not_to be_persisted
    end

    it "should not create two user with same email" do
      user = User.create(email: "user1@example.com", password: "password")
      expect(user).to be_persisted

      user2 = User.create(email: "user1@example.com", password: "password")
      expect(user2).not_to be_persisted
    end
  end
end
