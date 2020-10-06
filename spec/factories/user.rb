require 'faker'

FactoryBot.define do
    factory :user do
        sequence(:email) { |n| "example#{n}@email.com" }
        password { "password" }
        password_confirmation { "password" }
        authentication_token { Faker::Alphanumeric.alphanumeric(number: 20) }
    end
end