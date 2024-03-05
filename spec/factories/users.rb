FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test-user#{n}" }
    sequence(:email) { |n| "test#{n}@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
    line_id { 'test_id' }
  end
end
