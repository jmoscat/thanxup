# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :owner do
    sequence(:email) { |n| "user#{n}@factory.com" }
    password { 'secret' }
    password_confirmation { 'secret' }
    first_name 'Jimmy'
    last_name 'Dean'
    prefix 'Mr.'
    city 'San Francisco'
    state 'California'
    country 'United States'
    address '1234 Test Street'
    zip_code '11111'
    area_code '111'
    number1 '111'
    number2 '1111'
    approved true
    company_name 'Thanxup'
  end
end
