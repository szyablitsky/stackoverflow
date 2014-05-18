FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "test_user#{n}" } 
    sequence(:email) { |n| "test#{n}@example.com" }
    password '12345678'
  end
end
