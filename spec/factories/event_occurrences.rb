FactoryGirl.define do
  factory :event_occurrence_object, :class => EventOccurrence do |f|
    f.starts_occurring_at Time.now.to_s
    f.ends_occurring_at Time.now.advance(hours: 1).to_s
  end

  factory :event_occurrence do |f|
    f.starting Time.now.to_s
    f.ending Time.now.advance(hours: 1).to_s
  end

  factory :event_occurrence_for_weekly_event1, :class => EventOccurrence do |f|
    f.starting Time.local(2015, 7, 1, 11, 0, 0).to_s
    f.ending Time.local(2015, 7, 1, 12, 30, 0).to_s
  end

  factory :event_occurrence_for_weekly_event2, :class => EventOccurrence do |f|
    f.starting Time.local(2015, 2, 1, 11, 0, 0).advance(weeks: 1).to_s
    f.ending Time.local(2015, 2, 1, 12, 30, 0).advance(weeks: 1).to_s
  end
    
end