# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    admin { false }
    department { "技術部" }
    basic_time { "2024-01-03T08:00:00.000+09:00" }
    work_time { "2024-01-03T07:30:00.000+09:00" }
    created_at { "2023-12-31T17:05:48.618+09:00" }
    updated_at { "2024-01-03T18:01:26.857+09:00" }
  end
end
