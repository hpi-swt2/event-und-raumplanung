
FactoryGirl.define do
  factory :event_template do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.user_id nil
  end
end
