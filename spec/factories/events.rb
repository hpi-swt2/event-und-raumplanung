
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
  end
end
