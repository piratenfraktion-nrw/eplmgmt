# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'user.3'
    email 'example@example.com'
    password 'changeme'
    password_confirmation 'changeme'
  end
end
