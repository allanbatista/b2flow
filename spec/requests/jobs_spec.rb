require 'rails_helper'

RSpec.describe "Jobs", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }
  let!(:project) { FactoryBot.create(:project, team: team) }
  let!(:job) { FactoryBot.create(:job, project: project) }

  describe "authenticate" do
    it "should fail authentication" do
      get jobs_path(team.name, project.name)
      expect(response).to have_http_status(401)
    end
  end

  describe "ensure has team and project defined" do
    it "should ensure set project" do
      get jobs_path("NOT_EXISTS", project.name), headers: { 'x-auth-token' => user.to_token  }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(data['message']).to eq("team with name \"NOT_EXISTS\" was not found. team is required")
    end
  end

  describe "GET /jobs" do
    it "list jobs" do
      get jobs_path(team.name, project.name), headers: { 'x-auth-token' => user.to_token  }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /jobs/:id" do
    it "should show a job" do
      get job_path(job.project.team.name, job.project.name, job.name), headers: { 'x-auth-token' => user.to_token  }

      response_job = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response_job['id']).to eq(job.id.to_s)
      expect(response_job['name']).to eq("default-job")
      expect(response_job['project_id']).to eq(job.project_id.to_s)
      expect(response_job['engine']).to eq('docker')
      expect(response_job['cron']).to eq("0 0 * * *")
      expect(response_job['enable']).to eq(true)
    end

    it "should return 404 when not found a job" do
      get job_path(job.project.team.name, job.project.name, "NOT_EXISTS"), headers: { 'x-auth-token' => user.to_token  }

      expect(response).to have_http_status(404)
    end
  end
end
