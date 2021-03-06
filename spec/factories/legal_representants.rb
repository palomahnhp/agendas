require 'faker'

FactoryGirl.define do
  factory :legal_representant do
    identifier { Faker::Number.number(10) }
    name { Faker::Name.first_name }
    first_surname { Faker::Name.last_name }
    second_surname { Faker::Name.last_name }
    phones { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    association :organization, factory: :organization
  end

end
