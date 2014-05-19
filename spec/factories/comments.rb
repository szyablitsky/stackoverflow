FactoryGirl.define do
  factory :comment do
    body 'comment body'
    association :author, factory: :user
    message
  end
end
