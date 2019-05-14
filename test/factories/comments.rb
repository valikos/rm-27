FactoryBot.define do
  factory :comment do
    title { FFaker::Lorem.word }
    body { FFaker::Lorem.paragraph }
    task { nil }
  end
end
