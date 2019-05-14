FactoryBot.define do
  factory :project do
    title { FFaker::Lorem.word }
    body { FFaker::Lorem.paragraph }

    after(:build) do |project|
      rand(2..14).times do
        project.tasks << FactoryBot.build(:task, project: project)
      end
    end
  end
end
