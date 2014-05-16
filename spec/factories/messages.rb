FactoryGirl.define do
  factory :message do
    body 'Question body'
    topic
    answer true
    author

    factory :question do
      answer false
    end

    factory :answer do
      sequence(:body) { |n| "Answer #{n}" }
    end
  end
end
