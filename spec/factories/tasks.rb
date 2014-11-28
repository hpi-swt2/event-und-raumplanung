FactoryGirl.define do
  factory :task do
    name 'A Task'
    done false
    description 'This is a task.'
    association :event_id, factory: :event
    association :user_id, factory: :user
    status "not_assigned"

    factory :assigned_task do
      status "pending"
    end

    factory :unassigned_task do
      status "not_assigned"
    end
  end
end