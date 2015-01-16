require_relative '../../app/models/event'
require 'spec_helper'

describe Event do

	before(:all) do
	  @open_event = FactoryGirl.create(:event)
    @upcoming_event = FactoryGirl.create(:upcoming_event)
	  @declined_event = FactoryGirl.create(:declined_event)
	  @approved_event = FactoryGirl.create(:approved_event)
	end

  it "should have options_for_sorted_by" do
    Event::options_for_sorted_by
  end
  it "has a valid factory" do
    factory = FactoryGirl.build(:event)
    expect(factory).to be_valid
  end

  it "should have the :is_private attribute" do
    @event = FactoryGirl.build(:event)
    @event.is_private == true or @event.is_private == false
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
    results = Event.room_ids([])
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

   it "should find overlapping events" do
    @event1 = FactoryGirl.create(:standardEvent)
    @event1.name = "Party1"
    @event2 = FactoryGirl.create(:standardEvent)
    @event2.name = "Party2"
    @event1.save
    @event2.save

    ## Case 1: same timeslot
    coliding_events = @event2.check_vacancy(@event1.rooms.map(&:id))
    expect(coliding_events.size).to eq 1
    expect(coliding_events[0].name).to eq "Party1"

    ## Case 2: same timeslots, but different rooms, results to no conflicts (
    @event2.rooms = []
    coliding_events = @event2.check_vacancy([@event1[:room_id].to_s])
    expect(coliding_events.size).to eq 0

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

describe "event order" do
    before(:all) do
      Event.destroy_all
      @event1 = FactoryGirl.create(:sortEvent1)
      @event2 = FactoryGirl.create(:sortEvent2)
      @event3 = FactoryGirl.create(:sortEvent3)
    end

    it "should sort by created at" do
      @events = Event.sorted_by("created_at_desc")
    end

    it "should sort by name" do
      @events = Event.sorted_by("name_desc")
      @order = @events.map { |event| event.name[1,1] }
      expect(@order).to eq ['2','3','1']
    end

    it "should sort by starts at" do
      @events = Event.sorted_by("starts_at_desc")
      @order = @events.map { |event| event.name[1,1] }
      expect(@order).to eq ['2','1','3']
    end

    it "should sort by ends at" do
      @events = Event.sorted_by("ends_at_desc")
      @order = @events.map { |event| event.name[1,1] }
      expect(@order).to eq ['1','2','3']
    end

    it "should sort by status" do
      @events = Event.sorted_by("status_desc")
      @order = @events.map { |event| event.name[1,1] }
      expect(@order).to eq ['2','3','1']
    end
    it "unexpected should raise error " do
      expect { Event.sorted_by("narf_desc") }.to raise_error
    end
  end

  describe "event search" do
    before(:all) do
      @event1 = FactoryGirl.create(:sortEvent1)
      @event2 = FactoryGirl.create(:sortEvent2)
      @event3 = FactoryGirl.create(:sortEvent3)
      @event = FactoryGirl.create(:standardEvent)
    end

    it "should find A1" do
      @events = Event.search_query("A1");
      expect(@events.size).to be >= 1
      expect(@events).to include @event1
    end
    it "should find all in room" do
      @events = Event.room_ids @event.rooms.map(&:id)
      expect(@events.size).to be >= 1
      expect(@events).to include @event
    end

  end
