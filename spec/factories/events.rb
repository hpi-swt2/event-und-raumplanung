
FactoryGirl.define do
  factory :event do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.participant_count 15
    f.starts_at Time.now
    f.ends_at Time.now + 7200
    f.is_private false
    f.user_id 122
    f.rooms { build_list :room, 1 }
  end

  factory :upcoming_event, :class => Event do
    sequence(:name) { |n| "Eventname#{n}" }
    description "Eventdescription"
    participant_count 15
    starts_at DateTime.now.advance(:days => +1)
    ends_at DateTime.now.advance(:days => +1, :hours => +1)
    is_private true
    user_id 122
    rooms { build_list :room, 1 }
  end

  factory :my_upcoming_event, :class => Event do
    sequence(:name) { |n| "Eventname#{n}" }
    description "Eventdescription"
    participant_count 15
    starts_at Date.new(9999, 9, 10)
    ends_at Date.new(9999, 10, 10)
    is_private true
    sequence(:user_id) { |id| id }
    rooms { build_list :room, 1 }
  end

  factory :standardEvent, parent: :event, :class => Event do 
    
   sequence(:name) { |n| "Party#{n}" }
   description "All night long glühwein for free"
   participant_count 80
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
   rooms { create_list :room, 1 }
  end

  factory :event_on_one_day_with_one_room, parent: :scheduledEvent do 
   ends_at_date (Time.now).strftime("%Y-%m-%d") 
   ends_at_time (Time.now).strftime("%H:%M:%S")
   rooms { create_list :room, 1 }
  end

  factory :event_suggestion, :class => Event do 
    starts_at Time.now + 1
    ends_at Time.now + 2
    user_id 122
    name 'Test'
    description 'Event Suggestion test instance'
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

  factory :event_today, parent: :event do
    starts_at DateTime.current.advance(:minutes => +2)
    ends_at DateTime.current.advance(:minutes => +3)
  end

  factory :declined_event, parent: :event_today do
    status 'declined'
  end

  factory :approved_event, parent: :event_today do
    status 'approved'
  end

  factory :daily_recurring_event, :class => Event do |f|
    f.name "Daily recurring"
    f.description "Eventdescription"
    f.participant_count 15
    f.is_private false

    starts_at = Time.local(2015, 8, 1, 8, 0, 0)
    f.starts_at starts_at

    ends_at = Time.local(2015, 8, 1, 9, 30, 0)
    f.ends_at ends_at

    schedule = IceCube::Schedule.new(starts_at, end_time: ends_at) do |s|
      s.add_recurrence_rule(IceCube::Rule.daily)
    end
    f.schedule schedule
    f.rooms { build_list :room, 1 }
  end

  factory :weekly_recurring_event, :class => Event do |f|
    f.name "Weekly recurring"
    f.description "Eventdescription"
    f.participant_count 15
    f.is_private false

    starts_at = Time.local(2015, 2, 1, 11, 0, 0)
    f.starts_at starts_at

    ends_at = Time.local(2015, 2, 1, 12, 30, 0)
    f.ends_at ends_at

    schedule = IceCube::Schedule.new(starts_at, end_time: ends_at) do |s|
      s.add_recurrence_rule(IceCube::Rule.weekly)
    end
    f.schedule schedule
    f.rooms { build_list :room, 1 }
  end

  factory :daily_recurring_terminating_event, :class => Event do |f|
    f.name "Daily recurring until x"
    f.description "Eventdescription terminating"
    f.participant_count 15
    f.is_private false
    f.rooms { build_list :room, 1 }

    starts_at = Time.local(2015, 8, 1, 8, 0, 0)
    f.starts_at starts_at

    ends_at = Time.local(2015, 8, 1, 9, 30, 0)
    f.ends_at ends_at

    schedule = IceCube::Schedule.new(starts_at, end_time: ends_at) do |s|
      rule = IceCube::Rule.daily
      rule.until(Time.local(2015, 8, 16, 0, 0, 0))
      s.add_recurrence_rule(rule)
    end
    f.schedule schedule
  end

  factory :upcoming_daily_recurring_event, parent: :daily_recurring_event do |f|
    starts_at = Time.now + 1.hours
    f.starts_at starts_at

    ends_at = starts_at + 1.hours
    f.ends_at ends_at

    schedule = IceCube::Schedule.new(starts_at, end_time: ends_at) do |s|
      s.add_recurrence_rule(IceCube::Rule.daily)
    end
    f.schedule schedule
  end

  factory :upcoming_daily_recurring_event2, parent: :daily_recurring_event do |f|
    starts_at = Time.now + 90.minutes
    f.starts_at starts_at

    ends_at = starts_at + 1.hours
    f.ends_at ends_at

    schedule = IceCube::Schedule.new(starts_at, end_time: ends_at) do |s|
      s.add_recurrence_rule(IceCube::Rule.daily)
    end
    f.schedule schedule
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

  factory :invalid_event_without_rooms, parent: :event do
    room_ids []
    rooms []
  end

  factory :conflictingEvent, parent: :event do 
      starts_at_date Time.now.strftime("%Y-%m-%d")
      ends_at_date (Time.now + 3600).strftime("%Y-%m-%d")
      starts_at_time Time.now.strftime("%H:%M:%S")
      ends_at_time (Time.now + 3600).strftime("%H:%M:%S")
  end 

end
