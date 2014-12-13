
FactoryGirl.define do
  factory :event do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.participant_count 15
    f.starts_at Date.today + 1
    f.ends_at Date.today + 1
    f.is_private true
    f.user_id 122
  end

  factory :upcoming_event, :class => Event do
    sequence(:name) { |n| "Eventname#{n}" }
    description "Eventdescription"
    participant_count 15
    starts_at Date.new(9999, 9, 10)
    ends_at Date.new(9999, 10, 10)
    is_private true
    user_id 122
  end
end
