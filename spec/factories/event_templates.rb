
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
end
