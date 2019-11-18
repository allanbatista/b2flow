FactoryBot.define do
  factory :job do
    name { "default-job" }
    project { FactoryBot.create(:project) }
    engine { "docker" }
    cron { "0 0 * * *" }
  end
end
