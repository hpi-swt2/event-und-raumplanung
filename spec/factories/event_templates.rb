
FactoryGirl.define do
  factory :event_templates do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.participant_count 15
    f.start_date Date.new + 100
    f.start_time Time.new + 100
    f.end_date Date.new + 100
    f.end_time Time.new + 100
    f.user_id 122
  end
end
