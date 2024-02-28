FactoryBot.define do
  factory :post do
    # title { "test-post" }
    sequence(:title) { |n| "post-#{n}" }
    # body { "test-body" }
    sequence(:body) { |n| "post-body-#{n}" }
    association :user
    association :cat
  end
end
