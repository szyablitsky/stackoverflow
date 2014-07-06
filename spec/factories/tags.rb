FactoryGirl.define do
  factory :tag do
    sequence(:name) { |i| "tag name #{i}" }
  end
end
