FactoryBot.define do
  factory :dag do
    name { "default-dag" }
    cron { "0 0 * * *" }
    enable { true }
  end
end
