FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "comment#{n}" }
    association :user
    association :post
  end
end
