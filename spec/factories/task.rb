FactoryGirl.define do
  factory :task do
  	name 'A Task'
  	description 'This is a task.'
  	association :event_id, factory: :event
  end
end