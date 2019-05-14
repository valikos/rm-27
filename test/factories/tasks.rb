FactoryBot.define do
  factory :task do
    title { FFaker::Lorem.word }
    body { FFaker::Lorem.paragraph }

    project { nil }

    after(:build) do |task|
      rand(2..14).times do
        task.comments << FactoryBot.build(:comment, task: task)
      end
    end
  end
end
