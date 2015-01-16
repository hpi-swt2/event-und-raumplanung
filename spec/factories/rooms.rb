FactoryGirl.define do
  factory :room do |f|
    f.name "Room"
    f.size 1
    equipment []
  end	
  
  factory :room1, parent: :room do |f|
    f.name 'HS1'
  	f.size 30
  end
  
  factory :room2, parent: :room do |f|
  	f.name 'HS2'
  	f.size 20
  end
  
  factory :room_with_equipment, parent: :room do |f|
  	f.name 'HS1'
  	f.size '20'
  	f.equipment [
  		FactoryGirl.build(:beamer),
  		FactoryGirl.build(:wlan)]
  end
  
  factory :room_with_bookings, parent: :room do |f|
  	f.name 'HS1'
  	f.size 200
  	f.bookings [
  		FactoryGirl.build(:gds),
  		FactoryGirl.build(:pt)]
  end
end
