require 'rails_helper'

RSpec.describe "Versions", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:project) { FactoryBot.create(:project, team: team) }
  let!(:job) { FactoryBot.create(:job, project: project) }
  let!(:headers) { {'x-auth-token' => user.to_token} }
  let!(:default_params) { { source: Rack::Test::UploadedFile.new(fixtures_path("jobs/versions/source.zip"), "application/zip", true) } }

  describe "ensure has team, project and job defined" do
    it "should ensure set team" do
      get versions_path("NOT_EXISTS", project.name, job.name), headers: headers

      data = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(data['message']).to eq("team with name \"NOT_EXISTS\" was not found. team is required")
    end

    it "should ensure set project" do
      get versions_path(team.name, "NOT_EXISTS", job.name), headers: headers

      data = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(data['message']).to eq("project with name \"NOT_EXISTS\" was not found. project is required")
    end

    it "should ensure set project" do
      get versions_path(team.name, project.name, "NOT_EXISTS"), headers: headers

      data = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(data['message']).to eq("job with name \"NOT_EXISTS\" was not found. job is required")
    end
  end

  context "GET /versions" do
    it 'should fail authentication' do
      get versions_path(team.name, project.name, job.name), params: default_params

      expect(response).to have_http_status(401)
    end
  end

  context "GET /versions" do
    it "should list all jobs" do
      10.times {|n| post versions_path(team.name, project.name, job.name), params: default_params, headers: headers }

      get versions_path(team.name, project.name, job.name), headers: headers

      data = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(data.size).to eq(10)
    end
  end

  context 'POST /versions' do
    it 'should create new version' do
      post versions_path(team.name, project.name, job.name), params: default_params, headers: headers

      expect(response).to have_http_status(201)
    end

    it "should not create a new version when source not sended" do
      post versions_path(team.name, project.name, job.name), headers: headers

      expect(response).to have_http_status(422)
    end
  end
end