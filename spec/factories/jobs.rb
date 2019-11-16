FactoryBot.define do
  factory :job do
    name { "MyString" }
    team { nil }
    project { nil }
    engine { "MyString" }
    scheduler { "MyString" }
  end
end
