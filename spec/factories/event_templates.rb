
FactoryGirl.define do
  factory :event_template do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.user_id 1
    f.participant_count 212
  end
end
