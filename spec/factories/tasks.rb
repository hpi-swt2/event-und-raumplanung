# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  anUser = FactoryGirl.create(:user)

  factory :task do
    name 'A Task'
    done false
    description 'This is a task.'
    association :event_id, factory: :event
    identity 'User:'+anUser.id.to_s
    status "not_assigned"

    factory :assigned_task do
      status "pending"
    end

    factory :unassigned_task do
      status "not_assigned"
    end
  end
end