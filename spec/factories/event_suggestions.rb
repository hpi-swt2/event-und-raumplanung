FactoryGirl.define do
  factory :event_suggestion do |f|
    f.starts_at Date.today + 1
    f.ends_at Date.today + 2
    f.user_id 122
    f.rooms { build_list :room, 3 }
  end
end
