require 'rails_helper'

RSpec.describe "Teams", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }

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

  describe "GET /teams/:id" do
    it "should get teams" do
      get team_path(team.name), headers: { 'x-auth-token' => user.to_token }

      response_team = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response_team.keys).to eq(%w(id name created_at updated_at))
      expect(response_team["id"]).to eq(team.id.to_s)
      expect(response_team["name"]).to eq(team.name)
      expect(response_team["created_at"]).to eq(team.created_at.strftime("%FT%T.%L%z"))
      expect(response_team["updated_at"]).to eq(team.updated_at.strftime("%FT%T.%L%z"))
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
      team = Team.create(name: "MyOtherTeam")
      expect(team).to be_persisted

      post teams_path, params: {name: "MyOtherTeam"}, headers: { 'x-auth-token' => user.to_token }

      expect(response).to have_http_status(422)
    end
  end

  describe "PATCH /teams" do
    it "should update team name" do
      team = Team.create(name: "SuperTeam")

      patch team_path(team.name), params: {name: "X-Team"}, headers: { 'x-auth-token' => user.to_token }

      team.reload
      expect(response).to have_http_status(200)
      expect(team.name).to eq('x-team')
    end

    it "should not update team with same name as other team" do
      team = Team.create(name: "SuperTeam")
      team2 = Team.create(name: "X-Team")

      patch team_path(team.name), params: {name: team2.name}, headers: { 'x-auth-token' => user.to_token }

      team.reload
      expect(response).to have_http_status(422)
      expect(team.name).to eq('superteam')
    end
  end
end
