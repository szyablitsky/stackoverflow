FactoryGirl.define do
  factory :topic do
    sequence(:title) { |n| "Question #{n}" }
    views 0

    after :create do |topic|
      create(:question, topic: topic)
      create(:subscription, topic: topic, user: topic.question.author)
    end

    factory :topic_with_answers do
      ignore { answers_count 5 }
      after :create do |topic, evaluator|
        create_list(:answer, evaluator.answers_count, topic: topic)
      end
    end
  end
end
