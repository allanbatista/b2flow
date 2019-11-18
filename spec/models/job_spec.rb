require 'rails_helper'

RSpec.describe Job, type: :model do
  let!(:team) { FactoryBot.create(:team) }
  let!(:project) { FactoryBot.create(:project) }

  context ".create" do
    it "should create a new job" do
      job = Job.create(name: "MyJob", project: project, engine: "docker", cron: "* * * * *")

      expect(job).to be_persisted
      expect(job.name).to eq("myjob")
      expect(job.project).to eq(project)
      expect(job.engine).to eq('docker')
      expect(job.start_at).to be_nil
      expect(job.end_at).to be_nil
      expect(job.cron).to eq("* * * * *")
      expect(job.enable).to eq(true)
    end

    it "should not create two jobs with same name for same project" do
      job = Job.create(name: "MyJob", project: project, engine: "docker")
      expect(job).to be_persisted

      job2 = Job.create(name: "MyJob", project: project, engine: "docker")
      expect(job2).not_to be_persisted
    end

    it "should not create when scheduler is invalid" do
      job = Job.create(name: "MyJob", project: project, engine: "docker", cron: "* * * * * *")
      expect(job).not_to be_persisted

      job = Job.create(name: "MyJob", project: project, engine: "docker", cron: "INVALID")
      expect(job).not_to be_persisted
    end

    it "should disable cron" do
      job = Job.create(name: "MyJob", project: project, engine: "docker", cron: "* * * * *")
      expect(job).to be_persisted
      expect(job.cron).to eq('* * * * *')

      job.update(cron: nil)
      expect(job).to be_persisted
      expect(job.cron).to be_nil
    end
  end

  context "#to_api" do
    it "should render correct to api" do
      job = Job.create(name: "MyJob", project: project, engine: "docker", cron: "* * * * *")

      expect(job.to_api).to eq({
         "id" => job.id.to_s,
         "project_id" => job.project.id.to_s,
         "name" => job.name,
         "created_at" => job.created_at.strftime("%FT%T.%L%z"),
         "updated_at" => job.updated_at.strftime("%FT%T.%L%z"),
         "engine" => "docker",
         "cron" => "* * * * *",
         "enable" => true,
         "start_at" => nil,
         "end_at" => nil
       })
    end
  end
end
