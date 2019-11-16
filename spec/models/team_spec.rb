require 'rails_helper'

describe Team do
  context '.create' do
    it 'should create new team' do
      team = Team.create(name: "MyTeam")

      expect(team).to be_persisted
      expect(team.name).to eq('myteam')
    end

    it "should not create two teams with same name" do
      team = Team.create(name: "MyTeam")
      expect(team).to be_persisted

      team2 = Team.create(name: "MyTeam")
      expect(team2).not_to be_persisted
    end
  end

  context '.update' do
    it "should change not change name from to to same name from other team" do
      team = Team.create(name: "MyTeam")
      expect(team).to be_persisted

      team2 = Team.create(name: "MyTeam2")
      expect(team2).to be_persisted

      team2.name = "MyTeam"
      expect(team2.save).to eq(false)
    end
  end
end