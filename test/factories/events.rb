FactoryGirl.define do
  factory :upcoming_event, :class => Event do
    name 'MyString'
    start_date '9999-10-13'
    start_time '11:00:00'
    end_date '9999-10-13'
    end_time '12:00:00'
    participant_count 1
  end
end