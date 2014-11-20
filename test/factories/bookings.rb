FactoryGirl.define do
	factory :gds, class: Booking do
		name 'GdS'
		start DateTime.now
	end
	
	factory :pt, class: Booking do
		name 'Pt'
		start DateTime.now.advance(days:2)
	end
end