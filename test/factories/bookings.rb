FactoryGirl.define do
  factory :upcoming_event, :class => Booking do
    name 'MyString'
    start '9999-10-13 19:00:56'
  end
  factory :past_event, :class => Booking do
    name 'MyString'
    start '2000-10-13 19:00:56'
  end
end