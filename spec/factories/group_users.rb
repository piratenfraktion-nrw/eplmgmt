# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_user do
    group nil
    user nil
    manager false
  end
end
