FactoryGirl.define do
  factory :topic do
    sequence(:title) { |n| "Question #{n}" }

    factory :topic_with_messages do
      ignore { answers_count 5 }
      after :create do |topic, evaluator|
        create(:question, topic: topic)
        create_list(:answer, evaluator.answers_count, topic: topic)
      end
    end
  end
end