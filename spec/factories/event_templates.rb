
FactoryGirl.define do
  factory :event_template do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.start_date Date.today + 1
    f.start_time Time.new
    f.end_date Date.today + 1
    f.end_time Time.new
    f.user_id 122
  end
end
