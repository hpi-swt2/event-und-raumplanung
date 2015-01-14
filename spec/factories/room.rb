FactoryGirl.define do
  factory :room, :class => Room do |f|
    f.name "Room"
    f.size 1
    equipment []
  end
end
