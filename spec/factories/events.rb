
FactoryGirl.define do
  factory :event do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.participant_count 15
    f.starts_at Time.now
    f.ends_at Time.now + 7200
    f.is_private false
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


  factory :standardEvent, :class => Event do 
    
   sequence(:name) { |n| "Party#{n}" }
   description "All night long glühwein for free"
   participant_count 80
   created_at DateTime.new(2014, 8, 1, 22, 35, 0)
   updated_at DateTime.new(2014, 8, 1, 22, 35, 0)
   user_id 767770
   is_private false 
   status "In Bearbeitung"
   starts_at DateTime.new(2015, 8, 1, 22, 35, 0)
   ends_at DateTime.new(2016, 8, 1, 22, 35, 0)
   rooms { build_list :room, 3 }
 end 

  factory :scheduledEvent, parent: :event do
   starts_at_date (Time.now).strftime("%Y-%m-%d")
   ends_at_date (Time.now + 7200).strftime("%Y-%m-%d")    # + 2h
   starts_at_time (Time.now).strftime("%H:%M:%S")
   ends_at_time (Time.now + 7200).strftime("%H:%M:%S")
   room_ids ['1'] 
   is_private false
  end

  factory :event_on_multiple_days_with_multiple_rooms, parent: :scheduledEvent do 
   ends_at_date (Time.now + 86400).strftime("%Y-%m-%d")    # + 24h
   ends_at_time (Time.now + 86400).strftime("%H:%M:%S")
   room_ids ['1', '2']
  end

  factory :event_on_one_day_with_multiple_rooms, parent: :scheduledEvent do 
   ends_at_date (Time.now).strftime("%Y-%m-%d") 
   ends_at_time (Time.now).strftime("%H:%M:%S")  
   room_ids ['1', '2']
  end

  factory :event_on_multiple_days_with_one_room, parent: :scheduledEvent do 
   ends_at_date (Time.now + 86400).strftime("%Y-%m-%d")    # + 24h
   ends_at_time (Time.now + 86400).strftime("%H:%M:%S")
   room_ids ['1']
  end

  factory :event_on_one_day_with_one_room, parent: :scheduledEvent do 
   ends_at_date (Time.now).strftime("%Y-%m-%d") 
   ends_at_time (Time.now).strftime("%H:%M:%S")
   room_ids ['1']
  end

  factory :event_suggestion, :class => Event do 
    starts_at Time.now + 1
    ends_at Time.now + 2
    user_id 122
    name 'Test'
    description 'Event Suggestion test instance'
    event_id 1
    participant_count 12
    status 'suggested'
    rooms { build_list :room, 3 }
  end

  factory :declined_event_suggestion, parent: :event_suggestion do
    status 'rejected_suggestion'
  end

  trait :with_assignments do
    after :create do |event|
      FactoryGirl.create_list :task, 2, :event => event
    end
  end

  trait :with_assignments_that_have_attachments do
    after :create do |event|
      FactoryGirl.create_list :task_with_attachment, 2, :event => event
    end
  end

  factory :declined_event, parent: :event do
    status 'declined'
  end

  factory :approved_event, parent: :event do
    status 'approved'
  end

  factory :sortEvent1, parent: :event do
    name "A1"
    starts_at Date.new(2111,1,1)
    ends_at Date.new(2333,1,1)
    status "AIn Bearbeitung"
  end

  factory :sortEvent2, parent: :event do
    name "Z2"
    starts_at Date.new(2112,1,1)
    ends_at Date.new(2333,1,1)
    status "CIn Bearbeitung"
  end

  factory :sortEvent3, parent: :event do
    name "M3"
    starts_at Date.new(2110,1,1)
    ends_at Date.new(2111,1,1)
    status "BIn Bearbeitung"
  end
end
