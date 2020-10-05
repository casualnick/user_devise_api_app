require 'faker'

FactoryBot.define do
    factory :user do
        sequence(:email) { |n| "example#{n}@email.com" }
        password { "password" }
        password_confirmation { "password" }
    end
end