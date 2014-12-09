
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

  factory :upcoming_event, :class => Event do |f|
    f.name "Eventname"
    f.description "Eventdescription"
    f.participant_count 15
    f.starts_at '9999-09-10'
    f.ends_at '9999-10-10'
    f.is_private true
    f.user_id 122
  end

  factory :weekly_recurring_event, :class => Event do |f|
    f.name "Weekly recurring"
    f.description "Eventdescription"
    f.participant_count 15
    f.starts_at Date.today + 1
    f.ends_at Date.today + 1
    f.is_private false
    schedule = IceCube::Schedule.new(now = Time.now) do |s|
      s.add_recurrence_rule(IceCube::Rule.daily)
    end
    f.schedule schedule.to_yaml
  end
end
