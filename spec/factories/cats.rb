FactoryBot.define do
  factory :cat do
    sequence(:name) { |n| "cat#{n}" }
    gender { :Female }
    association :user
    association :cat_breed
  end
end