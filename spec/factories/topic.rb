FactoryGirl.define do
  factory :topic do
    sequence(:title) { |n| "Question #{n}" }
  end
end