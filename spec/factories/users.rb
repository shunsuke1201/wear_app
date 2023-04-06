FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    password { Faker::Internet.password(min_length: 8) }
    email { Faker::Internet.email }
    height { rand(100..200) }
    weight { rand(30..100) }
  end
end