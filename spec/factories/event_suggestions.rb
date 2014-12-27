FactoryGirl.define do
  factory :event_suggestion, :class => EventSuggestion do 
    starts_at Date.today + 1
    ends_at Date.today + 2
    user_id 122
    rooms { build_list :room, 3 }
  end

  factory :valid_attributes_for_event_suggestion, :class => EventSuggestion do
    starts_at_date (Date.today + 1).strftime("%Y-%m-%d")
    ends_at_date (Date.today + 2).strftime("%Y-%m-%d")
    starts_at_time (Date.today).strftime("%H:%M")
    ends_at_time (Date.today).strftime("%H:%M")
    user_id 122
  end

  factory :invalid_attributes_for_event_suggestion, :class => EventSuggestion do
    starts_at_date (Date.today - 1).strftime("%Y-%m-%d")
    ends_at_date (Date.today - 1).strftime("%Y-%m-%d")
    starts_at_time (Date.today).strftime("%H:%M")
    ends_at_time (Date.today).strftime("%H:%M")
    user_id 122
  end 
end
