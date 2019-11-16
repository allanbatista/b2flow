require 'rails_helper'

RSpec.describe Project, type: :model do
  let!(:team) { FactoryBot.create(:team) }

  context ".create" do
    it "should create a new project" do
      project = Project.create(name: "ProjectName", team: team)

      expect(project).to be_persisted
      expect(project.name).to eq('projectname')
    end

    it "should not create a project without team" do
      project = Project.create(name: "ProjectName")

      expect(project).not_to be_persisted
    end

    it "should not create a project with name duplicated for a team" do
      project = Project.create(name: "ProjectName", team: team)
      expect(project).to be_persisted

      project2 = Project.create(name: "ProjectName", team: team)
      expect(project2).not_to be_persisted
    end

    it "should create two projects with same name for diff teams" do
      project = Project.create(name: "ProjectName", team: team)
      expect(project).to be_persisted

      project2 = Project.create(name: "ProjectName", team: FactoryBot.create(:team, name: "Team2"))
      expect(project2).to be_persisted
    end
  end

  context "#to_api" do
    it "should render correct to_api" do
      project = Project.create(name: "ProjectName", team: team)

      expect(project.to_api).to eq({
        "id" => project.id.to_s,
        "team_id" => project.team.id.to_s,
        "name" => project.name,
        "created_at" => project.created_at.strftime("%FT%T.%L%z"),
        "updated_at" => project.updated_at.strftime("%FT%T.%L%z")
      })
    end
  end
end
