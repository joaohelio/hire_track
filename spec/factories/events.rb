FactoryBot.define do
  factory :event do
    trait :for_job do
      status { "activated" }
      data { {} }
      association :eventable, factory: :job
    end

    trait :for_application do
      status { "interview" }
      data { {interview_date: Date.today.iso8601} }

      association :eventable, factory: :application
    end
  end
end
