FactoryBot.define do
  factory :job_execution do
    status { "MyString" }
    job { nil }
    job_version { nil }
    started_at { "2019-11-25 13:21:45" }
    finished_at { "2019-11-25 13:21:45" }
  end
end
