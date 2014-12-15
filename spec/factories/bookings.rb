FactoryGirl.define do

  factory :booking do
  	name 'name of booking'
  	description 'description of booking'
  end

  factory :booking_yesterday, parent: :booking do |f|
  	f.start Date.current.yesterday.end_of_day
  	f.end Date.current.yesterday.end_of_day
  end
  
  factory :booking_today, parent: :booking do |f|
  	f.start Date.current.beginning_of_day
  	f.end Date.current.end_of_day
  end

  factory :booking_tomorrow, parent: :booking do |f|
  	f.start Date.current.tomorrow.beginning_of_day
  	f.end Date.current.tomorrow.beginning_of_day
  end

end
