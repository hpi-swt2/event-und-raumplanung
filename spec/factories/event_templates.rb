
FactoryGirl.define do
  factory :event_template do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.user_id 1
    f.participant_count 212
  end

  factory :sortEventT1, parent: :event_template do
    name "A1"
  end
  factory :sortEventT2, parent: :event_template do
    name "Z2"
  end
  factory :sortEventT3, parent: :event_template do
    name "M3"
  end

  trait :with_task do
    after :create do |event_template|
      FactoryGirl.create :task, :event_template => event_template
    end
  end

  trait :with_tasks do
    after :create do |event_template|
      FactoryGirl.create_list :task, 2, :event_template => event_template
    end
  end

  trait :with_tasks_that_have_attachments do
    after :create do |event_template|
      FactoryGirl.create_list :task_with_attachment, 2, :event_template => event_template
    end
  end
end
