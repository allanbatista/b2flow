require 'rails_helper'

RSpec.describe "/projects", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:team2) { FactoryBot.create(:team, name: "Team2") }
  let!(:project) { FactoryBot.create(:project, team: team) }

  describe "authentication" do
    it "should authentication fail" do
      get projects_path(team.name)
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /projects" do
    it "works! (now write some real specs)" do
      get projects_path(team.name), headers: { 'x-auth-token' => user.to_token }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /teams/:id" do
    it "should show project" do
      get project_path(team.name, project.name), headers: { 'x-auth-token' => user.to_token }

      response_project = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response_project.keys).to eq(%w(id name team_id created_at updated_at))
      expect(response_project["id"]).to eq(project.id.to_s)
      expect(response_project["name"]).to eq(project.name)
      expect(response_project["team_id"]).to eq(project.team.id.to_s)
      expect(response_project["created_at"]).to eq(project.created_at.strftime("%FT%T.%L%z"))
      expect(response_project["updated_at"]).to eq(project.updated_at.strftime("%FT%T.%L%z"))
    end
  end

  describe "POST /projects" do
    it "should create a new project" do
      post projects_path(team.name), params: {name: "X-Project"}, headers: { 'x-auth-token' => user.to_token }

      response_project = JSON.parse(response.body)

      expect(response).to have_http_status(201)
      expect(response_project['name']).to eq('x-project')
      expect(response_project["team_id"]).to eq(team.id.to_s)
    end

    it "should not create two projects with same name" do
      project = Project.create(name: "MyOtherProject", team: team)
      expect(project).to be_persisted

      post projects_path(team.name), params: {name: "MyOtherProject"}, headers: { 'x-auth-token' => user.to_token }

      expect(response).to have_http_status(422)
    end

    it "should create two projects with same name for diff teams" do
      project = Project.create(name: "MyOtherProject", team: team)
      expect(project).to be_persisted

      post projects_path(team2.name), params: {name: "MyOtherProject"}, headers: { 'x-auth-token' => user.to_token }
      expect(response).to have_http_status(201)
    end
  end

  describe "PATCH /projects" do
    it "should update team name" do
      project = Project.create(name: "ProjectName", team: team)

      patch project_path(team.name, project.name), params: {name: "X-Super-Project"}, headers: { 'x-auth-token' => user.to_token }

      project.reload
      expect(response).to have_http_status(200)
      expect(project.name).to eq('x-super-project')
    end

    it "should not update project with same name as other project name from same team" do
      project = Project.create(name: "SuperProject", team: team)
      project2 = Project.create(name: "X-Project", team: team)

      patch project_path(team.name, project.name), params: {name: project2.name}, headers: { 'x-auth-token' => user.to_token }

      project.reload
      expect(response).to have_http_status(422)
      expect(project.name).to eq('superproject')
    end
  end
end
