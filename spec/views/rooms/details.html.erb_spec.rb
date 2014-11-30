require 'rails_helper'

RSpec.describe "rooms/details.html.erb" do
	it "must run" do
		1.should == 1
	end
  
	it "must display the information of the room" do
		assign(:room, FactoryGirl.build(:room1))
		render
		expect(rendered).to include("HS1")
		expect(rendered).to include("30")
	end
	
	it "must display both equipment" do
		room = FactoryGirl.build(:room_with_equipment)
		assign(:room, room)
		render
		expect(rendered).to include("hpi")
		expect(rendered).to include("Beamer")
	end
	
	it "must display the equipment information" do
		room = FactoryGirl.build(:room_with_equipment)
		assign(:room, room)
		render
		expect(rendered).to include(room.equipment.first.name)
		expect(rendered).to include(room.equipment.last.name)
		expect(rendered).to include(room.equipment.first.description)
		expect(rendered).to include(room.equipment.last.description)
	end
	
	it "must have two events" do
		room = FactoryGirl.build(:room_with_bookings)
		room.bookings.size.should == 2
	end
	
	it "must not show both events, only the first" do
		room = FactoryGirl.build(:room_with_bookings)
		#This is here because you can't set the 'end' attribute in FactoryGirl, at least I can't
		room.bookings.first.end = DateTime.now.advance(hours: 2)
		room.bookings.last.end = DateTime.now.advance(days: 2, hours: 1)
		room.bookings.first.start.to_date.should == Date.today
		assign(:room, room)
		render
		expect(rendered).to include(room.bookings.first.name)
		expect(rendered).to_not include(room.bookings.last.name)
	end
	
	it "must show all information" do
		room = FactoryGirl.build(:room_with_bookings)
		room.bookings.first.end = DateTime.now
		assign(:room, room)
		render
		expect(rendered).to include(room.bookings.first.name)
		expect(rendered).to include(room.bookings.first.start.to_s(:time))
		expect(rendered).to include(room.bookings.first.end.to_s(:time))
	end
end