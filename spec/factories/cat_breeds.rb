FactoryBot.define do
  factory :cat_breed do
    sequence(:name) { |n| "cat-breed#{n}" }
  end
end