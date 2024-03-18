FactoryBot.define do
  factory :cat do
    sequence(:name) { |n| "cat#{n}" }
    gender { :Female }
    sequence(:self_introduction) { |n| "self_introduction#{n}" }
    association :user
    association :cat_breed
  end
end