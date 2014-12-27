
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


  factory :standardEvent, :class => Event do 
    
   sequence(:name) { |n| "Party#{n}" }
   description "All night long glühwein for free"
   participant_count 80
   created_at DateTime.new(2014, 8, 1, 22, 35, 0)
   updated_at DateTime.new(2014, 8, 1, 22, 35, 0)
   user_id 767770
   is_private false 
   approved nil
   status "In Bearbeitung"
   starts_at DateTime.new(2015, 8, 1, 22, 35, 0)
   ends_at DateTime.new(2016, 8, 1, 22, 35, 0)
   rooms { build_list :room, 3 }
 end 

  factory :scheduledEvent, :class => Event do
   name'Michas GB'
   description'Coole Sache'
   participant_count 2000
   starts_at_date'2020-08-23'
   ends_at_date'2020-08-23'
   starts_at_time'17:00'
   ends_at_time'23:59'
   room_ids ['1'] 
  end

  factory :event_on_multiple_days_with_multiple_rooms, :class => Event do 
   name 'Michas GB'
   description 'Coole Sache'
   participant_count 2000
   starts_at_date '2020-08-23'
   ends_at_date '2020-08-24'
   starts_at_time '17:00'
   ends_at_time '23:59'
   room_ids ['1', '2']
  end

  factory :event_on_one_day_with_multiple_rooms, :class => Event do 
   name 'Michas GB'
   description 'Coole Sache'
   participant_count 2000
   starts_at_date '2020-08-23'
   ends_at_date '2020-08-23'
   starts_at_time '17:00'
   ends_at_time '23:59'
   room_ids ['1', '2']
  end

  factory :event_on_multiple_days_with_one_room, :class => Event do 
   name 'Michas GB'
   description 'Coole Sache'
   participant_count 2000
   starts_at_date '2020-08-23'
   ends_at_date '2020-08-24'
   starts_at_time '17:00'
   ends_at_time '23:59'
   room_ids ['1']
  end

  factory :event_on_one_day_with_one_room, :class => Event do 
   name 'Michas GB'
   description 'Coole Sache'
   participant_count 2000
   starts_at_date '2020-08-23'
   ends_at_date '2020-08-23'
   starts_at_time '17:00'
   ends_at_time '23:59'
   room_ids ['1']
  end

  factory :event_valid_attributes, :class => Event do 
    name 'Michas GB'
    description 'Coole Sache'
    participant_count 2000
    starts_at_date (Date.today + 1).strftime("%Y-%m-%d")
    ends_at_date (Date.today + 2).strftime("%Y-%m-%d")
    starts_at_time (Date.today).strftime("%H:%M")
    ends_at_time (Date.today).strftime("%H:%M")
    user_id 122
    room_ids ['1']
  end

  factory :event_invalid_attributes, :class => Event do 
    name 'Michas GB'
    description 'Coole Sache'
    participant_count 2000
    starts_at_date (Date.today - 1).strftime("%Y-%m-%d")
    ends_at_date (Date.today - 2).strftime("%Y-%m-%d")
    starts_at_time (Date.today).strftime("%H:%M")
    ends_at_time (Date.today).strftime("%H:%M")
    user_id 122
    room_ids ['1']
  end
  # factory :scheduledEvent, :class => Event do 
  #  sequence(:name) { |n| "Party#{n}" }
  #  description "All night long glühwein for free"
  #  participant_count 80
  #  created_at DateTime.new(2014, 8, 1, 22, 35, 0)
  #  updated_at DateTime.new(2014, 8, 1, 22, 35, 0)
  #  user_id 767770
  #  is_private false 
  #  approved nil
  #  status "In Bearbeitung"
  #  starts_at DateTime.new(2015, 8, 1, 22, 35, 0)
  #  ends_at DateTime.new(2016, 8, 1, 22, 35, 0)
  #  rooms { FactoryGirl.build(:room1) }
  # end 

  # factory :colidingEvent, :class => Event do 
  #  starts_at DateTime.new(2015, 8, 1, 22, 35, 0)
  #  ends_at DateTime.new(2016, 8, 1, 22, 35, 0)
  #  rooms { FactoryGirl.build(:room1) }
  #  user_id 767770
  # end 

  # factory :notColidingEvent, :class => Event do 
  #  starts_at DateTime.new(2015, 8, 1, 22, 35, 0)
  #  ends_at DateTime.new(2016, 8, 1, 22, 35, 0)
  #  rooms { FactoryGirl.build(:room2) }
  #  user_id 767770
  # end 

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
