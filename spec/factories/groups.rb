# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    name ENV['UNGROUPED_NAME']
    creator_id 1
  end
end
