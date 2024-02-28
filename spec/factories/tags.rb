FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "tag-name#{n}" }
  end
end
