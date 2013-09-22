# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pad do
    pad_id "MyString"
    group nil
    name "MyString"
    password "MyString"
    creator_id 1
  end
end
