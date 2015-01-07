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

  it "should be private by default" do
    event = build(:event)
    expect(event.is_private).to be true
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

	it ".approve should set approve status in an event" do
    	event = build(:event)
    	event.approve
    	expect(Event.approved.find(event)).to eq(event)
 	end

 	it ".decline should set decline status in an event" do
    	event = build(:event)
    	event.decline
    	expect(Event.declined.find(event)).to eq(event)
 	end

 	it ".is_approved should only return true for an approved event" do
    	expect(@open_event.is_approved).to be false
    	expect(@declined_event.is_approved).to be false
    	expect(@approved_event.is_approved).to be true
 	end

   it "should find time overlapping events" do
    @event1 = FactoryGirl.create(:standardEvent)
 
    @event2 = FactoryGirl.create(:standardEvent)


    ## the following line is taken from checkVacancy
    events =  Event.other_to(@event2.id).not_approved.overlapping(@event2.starts_at,@event2.ends_at)
    expect(events.size).to eq 1
    expect(events[0].name).to eq @event1.name

    @event1.destroy
    @event2.destroy


  end

   it "SHOULD find overlapping events" do
    ## THIS IS STILL IN PROGRESS
    ## The test will fail, because there is no translation table for the rooms
    @event1 = FactoryGirl.create(:standardEvent)
    #@event1.name = "Party1"
    @event2 = FactoryGirl.create(:standardEvent)
    #@event2.name = "Party2"

    ## Case 1: same timeslot 
    #coliding_events = @event2.checkVacancy([@event1[:room_id]])
    #expect(coliding_events.size).to eq 1
    #expect(coliding_events[0].name).to eq "Party1" 

    ## Case 2: same timeslots, but different rooms, results to no conflicts (
    #@event2.room_id = 2 
    #coliding_events = @event2.checkVacancy([@event1[:room_id].to_s])
    #expect(coliding_events.size).to eq 0
    #puts coliding_events.inspect

    ## Case 3: more than one room 
  

    @event1.destroy
    @event2.destroy

  end

	after(:all) do
		@open_event.destroy
		@declined_event.destroy
		@approved_event.destroy
    @upcoming_event.destroy
	end


end
