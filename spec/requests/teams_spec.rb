require 'rails_helper'

RSpec.describe "Teams", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "authentication" do
    it "should authentication fail" do
      get teams_path
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /teams" do
    it "works! (now write some real specs)" do
      get teams_path, headers: { 'x-auth-token' => user.to_token }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /teams" do
    it "should create a new team" do
      post teams_path, params: {name: "X-Team"}, headers: { 'x-auth-token' => user.to_token }

      team = JSON.parse(response.body)

      expect(response).to have_http_status(201)
      expect(team['name']).to eq('x-team')
    end

    it "should not create two teams with same name" do
      team = Team.create(name: "MyTeam")
      expect(team).to be_persisted

      post teams_path, params: {name: "MyTeam"}, headers: { 'x-auth-token' => user.to_token }

      expect(response).to have_http_status(422)
    end
  end
end
