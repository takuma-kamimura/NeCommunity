FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test-user#{n}" }
    sequence(:email) { |n| "test#{n}@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
    line_id { 'test_id' }
    self_introduction { '' }
  end

  trait :general do
    role { :general }
  end

  trait :admin do
    role { :admin }
  end
end
