
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

  factory :my_upcoming_event, :class => Event do
    sequence(:name) { |n| "Eventname#{n}" }
    description "Eventdescription"
    participant_count 15
    starts_at Date.new(9999, 9, 10)
    ends_at Date.new(9999, 10, 10)
    is_private true
    sequence(:user_id) { |id| id }
  end

  factory :standardEvent, :class => Event do 
    
   sequence(:name) { |n| "Party#{n}" }
   description "All night long glühwein for free"
   participant_count 80
   created_at DateTime.new(2014, 8, 1, 22, 35, 0)
   updated_at DateTime.new(2014, 8, 1, 22, 35, 0)
   user_id 767770
   room_id 1
   is_private false 
   approved nil
   status "In Bearbeitung"
   starts_at DateTime.new(2015, 8, 1, 22, 35, 0)
   ends_at DateTime.new(2016, 8, 1, 22, 35, 0)
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
