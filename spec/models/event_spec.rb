require_relative '../../app/models/event'
require 'spec_helper'

describe Event do

	before(:all) do
	  @open_event = FactoryGirl.create(:event)
    @upcoming_event = FactoryGirl.create(:upcoming_event)
	  @declined_event = FactoryGirl.create(:declined_event)
	  @approved_event = FactoryGirl.create(:approved_event)
	end

  it "has a valid factory" do
    factory = FactoryGirl.build(:event)
    expect(factory).to be_valid
  end

  it "should have the :is_private attribute" do
    @event = FactoryGirl.build(:event)
    @event.is_private == true or @event.is_private == false
  end

  it "SHOULD find overlapping events" do
  	## THIS IS STILL IN PROGRESS BUT WE WANT TO SHARE OUR AMAZING WORK RIGHT NOW
  	@event1 = FactoryGirl.create(:standardEvent)
  	@event2 = FactoryGirl.create(:standardEvent)

  	puts Event.where(true).inspect

  	coliding_events = @event2.checkVacancy([@event1[:room_id]])
  	#coliding_events = @event2.checkVacancy([1,2,3])
  	puts coliding_events.inspect
  	#expect
  	@event1.destroy
  	@event2.destroy

  end

  it 'should return events after a certain date' do
    date = @upcoming_event.starts_at.advance(:hours => -1).strftime("%d.%m.%Y %H:%M Uhr")
    results = Event.starts_after(date)
    expect(results).to include(@upcoming_event)
    date = @upcoming_event.starts_at.advance(:hours => +1).strftime("%d.%m.%Y %H:%M Uhr")
    results = Event.starts_after(date)
    expect(results).not_to include(@upcoming_event)
  end

  it 'should return events before a certain date' do
    date = @upcoming_event.ends_at.advance(:hours => +1).strftime("%d.%m.%Y %H:%M Uhr")
    results = Event.ends_before(date)
    expect(results).to include(@upcoming_event)
    date = @upcoming_event.ends_at.advance(:hours => -1).strftime("%d.%m.%Y %H:%M Uhr")
    results = Event.ends_before(date)
    expect(results).not_to include(@upcoming_event)
  end

  it 'should return events for a room' do
    room = FactoryGirl.create(:room)
    another_room = FactoryGirl.create(:room)
    results = Event.room_ids(nil)
    expect(results).to include(@upcoming_event)
    @upcoming_event.rooms << room
    results = Event.room_ids([room.id, another_room.id])
    expect(results).to include(@upcoming_event)
    results = Event.room_ids([another_room.id])
    expect(results).not_to include(@upcoming_event)
  end

  it 'should return events with a minimum number of participants' do
    results = Event.participants_gte(@upcoming_event.participant_count)
    expect(results).to include(@upcoming_event)
    results = Event.participants_gte(@upcoming_event.participant_count + 1)
    expect(results).not_to include(@upcoming_event)
  end

  it 'should return events with a maximum number of participants' do
    results = Event.participants_lte(@upcoming_event.participant_count)
    expect(results).to include(@upcoming_event)
    results = Event.participants_lte(@upcoming_event.participant_count - 1)
    expect(results).not_to include(@upcoming_event)
  end

  it 'should return events for a certain user' do
    results = Event.user(nil)
    expect(results).to include(@upcoming_event)
    results = Event.user(@upcoming_event.user_id)
    expect(results).to include(@upcoming_event)
    results = Event.user(@upcoming_event.user_id + 1)
    expect(results).not_to include(@upcoming_event)
  end

  it 'should return events for a search query' do
    results = Event.search_query(@upcoming_event.name)
    expect(results).to include(@upcoming_event)
    results = Event.search_query(@upcoming_event.name[0])
    expect(results).to include(@upcoming_event)
    results = Event.search_query(@upcoming_event.name + 'a')
    expect(results).not_to include(@upcoming_event)
  end

  it ".open should only return open events" do
	  results = Event.open
	  expect(results).to include(@open_event)
	  expect(results).not_to include(@declined_event, @approved_event)
	end

	it ".approved should only return approved events" do
	  results = Event.approved
	  expect(results).to include(@approved_event)
	  expect(results).not_to include(@declined_event, @open_event)
	end

	it ".decline should only return declined events" do
	  results = Event.declined
	  expect(results).to include(@declined_event)
	  expect(results).not_to include(@approved_event, @open_event)
	end

	after(:all) do
    @upcoming_event.destroy
		@open_event.destroy
		@declined_event.destroy
		@approved_event.destroy
	end

end
