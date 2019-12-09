require 'rails_helper'

RSpec.describe "Dags", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:project) { FactoryBot.create(:project, team: team) }
  let!(:dag) { FactoryBot.create(:dag, project: project, team: team) }

  describe "authenticate" do
    it "should fail authentication" do
      get dags_path(team.name, project.name)
      expect(response).to have_http_status(401)
    end
  end

  describe "ensure has team and project defined" do
    it "should ensure set team" do
      get dags_path("NOT_EXISTS", project.name), headers: { 'x-auth-token' => user.to_token  }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(data['message']).to eq("team with name \"NOT_EXISTS\" was not found. team is required")
    end

    it "should ensure set project" do
      get dags_path(team.name, "NOT_EXISTS"), headers: { 'x-auth-token' => user.to_token  }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(data['message']).to eq("project with name \"NOT_EXISTS\" was not found. project is required")
    end
  end

  describe "GET /dags" do
    it "list dags" do
      get dags_path(team.name, project.name), headers: { 'x-auth-token' => user.to_token  }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /dags/:dag_name" do
    it "should show a job" do

      get dag_path(dag.team.name, dag.project.name, dag.name), headers: { 'x-auth-token' => user.to_token  }

      response_job = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response_job['id']).to eq(dag.id.to_s)
      expect(response_job['name']).to eq("default-dag")
      expect(response_job['team_id']).to eq(dag.team_id.to_s)
      expect(response_job['project_id']).to eq(dag.project_id.to_s)
      expect(response_job['cron']).to eq("0 0 * * *")
      expect(response_job['enable']).to eq(true)
    end

    it "should return 404 when not found a job" do
      get dag_path(dag.team.name, dag.project.name, "NOT_EXISTS"), headers: { 'x-auth-token' => user.to_token  }

      expect(response).to have_http_status(404)
    end
  end

  describe "POST /dags" do
    it "should create a new dag" do
      params = {
          name: "new-dag",
          cron: '1 1 * * *',
          enable: true,
          # source: Rack::Test::UploadedFile.new(fixtures_path('dags/source.zip')),
          source: Base64.encode64(File.read(fixtures_path('dags/source.zip'))),
          config: {
              jobs: {
                  job1: {
                      engine: "docker",
                      cpu: 4,
                      memory: "16GB"
                  },
                  job2: {
                      engine: "spark",
                      cpu: 16,
                      memory: "64GB",
                      nodes: 8
                  },
                  job3: {
                      engine: "pyflow",
                      cpu: 16,
                      memory: "64GB",
                      depends: %w(job1 job2)
                  }
              }
          }
      }

      post dags_path(team.name, project.name), params: params, headers: { 'x-auth-token' => user.to_token  }

      response_dag = JSON.parse(response.body)
      expect(response).to have_http_status(201)
      expect(response_dag['name']).to eq("new-dag")
      expect(response_dag['project_id']).to eq(project.id.to_s)
      expect(response_dag['cron']).to eq("1 1 * * *")
      expect(response_dag['enable']).to eq(true)
      expect(response_dag['config']).to eq({"jobs"=>{"job1"=>{"engine"=>"docker", "cpu"=>"4", "memory"=>"16GB"}, "job2"=>{"engine"=>"spark", "cpu"=>"16", "memory"=>"64GB", "nodes"=>"8"}, "job3"=>{"engine"=>"pyflow", "cpu"=>"16", "memory"=>"64GB", "depends"=>["job1", "job2"]}}})
    end

    it "should not create without a name" do
      params = {
          cron: '1 1 * * *'
      }

      post dags_path(project.team.name, project.name), params: params, headers: { 'x-auth-token' => user.to_token  }

      expect(response).to have_http_status(422)
    end
  end

  describe "PATCH /dags/:dag_name" do
    it "should create a new job" do
      params = {
          cron: '1 1 1 1 1'
      }

      patch dag_path(dag.team.name, dag.project.name, dag.name), params: params, headers: { 'x-auth-token' => user.to_token  }

      response_job = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response_job['cron']).to eq("1 1 1 1 1")
    end
  end
end
