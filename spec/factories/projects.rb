FactoryBot.define do
  factory :project do
    name { "MyString" }
    team { FactoryBot.create(:team, name: "MyTeamProject") }
  end
end
