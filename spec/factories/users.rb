FactoryBot.define do
  factory :user do
    name { "test" }
    sequence(:email) { |n| "test#{n}@email.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
