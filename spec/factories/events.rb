
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
    starts_at DateTime.now.advance(:days => +1)
    ends_at DateTime.now.advance(:days => +1, :hours => +1)
    is_private true
    user_id 122
  end

  factory :standardEvent, :class => Event do |f|
    #  with all attributes :)
   f.name "A big Celebration"
   f.description "All night long glühwein for free"
   f.participant_count 80
   f.created_at DateTime.new(2014, 8, 1, 22, 35, 0)
   f.updated_at DateTime.new(2014, 8, 1, 22, 35, 0)
   f.user_id 767770
   f.room_id 1
   f.is_private false
   f.approved nil
   f.status "In Bearbeitung"
   f.starts_at DateTime.new(2015, 8, 1, 22, 35, 0)
   f.ends_at DateTime.new(2016, 8, 1, 22, 35, 0)
   #f.start_date
   #f.start_time Time.new(22, 35)
   # f.end_date
    #f.end_time
  end

  factory :declined_event, parent: :event do
    status 'declined'
  end
  factory :approved_event, parent: :event do
    status 'approved'
  end
end
