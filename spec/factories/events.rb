
FactoryGirl.define do
  factory :event do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.participant_count 15
    f.start_date Date.today + 1
    f.start_time Time.new
    f.end_date Date.today + 1
    f.end_time Time.new
    f.is_private true
    f.user_id 122
  end

  factory :upcoming_event, :class => Event do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.participant_count 15
    start_date '9999-10-13'
    start_time '11:00:00'
    end_date '9999-10-13'
    end_time '12:00:00'
    f.is_private true
    f.user_id 122
  end
end
