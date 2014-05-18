FactoryGirl.define do
  factory :topic do
    sequence(:title) { |n| "Question #{n}" }

    after :create do |topic|
      create(:question, topic: topic)
    end

    factory :topic_with_answers do
      ignore { answers_count 5 }
      after :create do |topic, evaluator|
        create_list(:answer, evaluator.answers_count, topic: topic)
      end
    end
  end
end
