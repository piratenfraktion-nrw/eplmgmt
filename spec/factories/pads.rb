# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pad do
    group_id 1
    name 'testungrouped'
    password ''
    creator_id 1
  end
end
