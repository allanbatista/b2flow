require 'rails_helper'

RSpec.describe "Settings", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:project) { FactoryBot.create(:project, team: team) }
  let!(:job) { FactoryBot.create(:job, project: project) }
  let!(:headers) { {'x-auth-token' => user.to_token} }

  describe "ensure has team, project and job defined" do
    it "should ensure set team" do
      get settings_path("NOT_EXISTS", project.name, job.name), headers: headers

      data = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(data['message']).to eq("team with name \"NOT_EXISTS\" was not found. team is required")
    end

    it "should ensure set project" do
      get settings_path(team.name, "NOT_EXISTS", job.name), headers: headers

      data = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(data['message']).to eq("project with name \"NOT_EXISTS\" was not found. project is required")
    end

    it "should ensure set project" do
      get settings_path(team.name, project.name, "NOT_EXISTS"), headers: headers

      data = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(data['message']).to eq("job with name \"NOT_EXISTS\" was not found. job is required")
    end
  end

  context "GET /settings" do
    it 'should fail authentication' do
      get settings_path(team.name, project.name, job.name)

      expect(response).to have_http_status(401)
    end
  end

  context "GET /settings" do
    it "should list all jobs" do
      10.times {|n| post settings_path(team.name, project.name, job.name), params: { settings: {} }, headers: headers }

      get settings_path(team.name, project.name, job.name), headers: headers

      data = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(data.size).to eq(10)
    end
  end

  context 'POST /settings' do
    it 'should create new version' do
      post settings_path(team.name, project.name, job.name), params: { settings: { "status" => "ok" } }, headers: headers

      setting = JSON.parse(response.body)
      expect(response).to have_http_status(201)
      expect(setting['settings']).to eq({"status" => "ok"})
    end
  end
end