FactoryGirl.define do
  factory :authorization do
    user nil
    provider 'facebook'
    uid 'user_uid'
  end
end
