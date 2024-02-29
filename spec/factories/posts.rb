FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "post-#{n}" }
    sequence(:body) { |n| "post-body-#{n}" }
    association :user
    association :cat
  end
end
