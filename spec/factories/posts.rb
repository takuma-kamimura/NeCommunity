FactoryBot.define do
  factory :post do
    title { "test-post" }
    body { "test-body" }
    association :user
    association :cat
  end
end
