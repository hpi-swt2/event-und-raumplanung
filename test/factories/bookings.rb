FactoryGirl.define do
	factory :gds, class: Booking do
		name 'GdS'
		start DateTime.current
	end
	
	factory :pt, class: Booking do
		name 'Pt'
		start DateTime.current.advance(days:2)
	end
end