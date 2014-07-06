FactoryGirl.define do
  factory :comment do
    sequence(:body) { |i| "comment #{i} body" }
    association :author, factory: :user
    message
  end
end
