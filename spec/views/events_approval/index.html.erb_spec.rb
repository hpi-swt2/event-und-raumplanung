require 'rails_helper'

RSpec.describe "events_approval/index", :type => :view do

	before(:all) do
		@user1 = FactoryGirl.create(:user, username: 'User239823049')
		@user2 = FactoryGirl.create(:user, username: 'User237473247')
		@room1 = FactoryGirl.create(:room, name: 'Room23922398')
		@room2 = FactoryGirl.create(:room, name: 'Room56232323')
	 	@open_event = FactoryGirl.create(:event_today, name: 'open_event', description: 'aasdafafqwfhdr', user_id: @user1.id, rooms: [@room1])
	 	@approved_event = FactoryGirl.create(:approved_event, name: 'approved_event', description: 'ieth234ihdsjf', user_id: @user2.id, rooms: [@room2])
		assign(:open_events, Event.find([@open_event]))
		assign(:approved_events, Event.find([@approved_event]))
		assign(:date, Date.current)
	end

	it 'should contain title' do
		render
		expect(rendered).to include 'Offene Buchungen' or 'Approve Events'
	end

	describe "an open event" do
		it 'should contain name and description' do
			render
			expect(rendered).to include @open_event.name, @open_event.description
		end
		it 'should display user name' do
			render
			expect(rendered).to include @user1.username
		end
		it 'should display room name' do
			render
			expect(rendered).to include @room1.name
		end
	end

	describe "an approved event" do
		it 'should contain an approved event' do
			render
			expect(rendered).to include @approved_event.name, @approved_event.description
		end
		it 'should display user name' do
			render
			expect(rendered).to include @user2.username
		end
		it 'should display room name' do
			render
			expect(rendered).to include @room2.name
		end
	end

	describe "without open events" do
		before(:all) do
			assign(:open_events, Event.find([]))
		end
		it 'should contain a message for no open evens' do
			render
			expect(rendered).to include 'Keine offenen Buchungen' or 'No open events'
		end
	end

	describe "without approved events" do
		before(:all) do
			assign(:approved_events, Event.find([]))
		end
		it 'should contain a message for no approved evens' do
			render
			expect(rendered).to include 'Keine genehmigten Buchungen' or 'No approved events'
		end
	end

	after(:all) do
		@open_event.destroy
		@approved_event.destroy
		@user1.destroy
		@user2.destroy
		@room1.destroy
		@room2.destroy
	end

end
