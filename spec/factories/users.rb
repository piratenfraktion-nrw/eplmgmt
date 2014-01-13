# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'user.3'
    email 'example@example.com'
    nickname 'nickname'
    password 'password'
    password_confirmation 'password'
  end
end
