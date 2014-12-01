FactoryGirl.define do
	factory :room1, class: Room do
		name 'HS1'
		size 30
	end
	
	factory :room2, class: Room do
		name 'HS2'
		size 20
	end
	
	factory :room_with_equipment, class: Room do
		name 'HS1'
		size '20'
		equipment [
			FactoryGirl.build(:beamer),
			FactoryGirl.build(:wlan)]
	end
	
	factory :room_with_bookings, class: Room do
		name 'HS1'
		size 200
		bookings [
			FactoryGirl.build(:gds),
			FactoryGirl.build(:pt)]
	end
	
end