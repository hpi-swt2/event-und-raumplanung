# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name 'A Task'
    done false
    description 'This is a task.'
    association :event_id, factory: :event
    association :identity, factory: :user
    status "not_assigned"

    factory :assigned_task do
      status "pending"
    end

    factory :unassigned_task do
      status "not_assigned"
      identity nil
    end
  end
end