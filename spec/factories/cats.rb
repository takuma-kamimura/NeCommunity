FactoryBot.define do
  factory :cat do
    name { "test-cat" }
    gender { :Female }
    association :user
    association :cat_breed
  end
end