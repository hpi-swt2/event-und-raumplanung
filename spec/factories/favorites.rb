
FactoryGirl.define do
  factory :no_favorite do |f|
    f.event_id 1
    f.user_id 1
    f.is_favorite false
  end

factory :favorite do |f|
    f.event_id 2
    f.user_id 1
    f.is_favorite true
  end
end