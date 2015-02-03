require_relative '../../app/models/event'
require 'spec_helper'

describe Event do
  let(:event) { FactoryGirl.create(:event) }

	before(:all) do
	  @open_event = FactoryGirl.create(:event)
    @upcoming_event = FactoryGirl.create(:upcoming_event)
	  @declined_event = FactoryGirl.create(:declined_event)
	  @approved_event = FactoryGirl.create(:approved_event)
	end

  after(:all) do
    @open_event.destroy
    @declined_event.destroy
    @approved_event.destroy
    @upcoming_event.destroy
  end

  let(:conflicting_event) { 
    { 
      starts_at_date: Time.now.strftime("%Y-%m-%d"),
      ends_at_date: (Time.now + 3600).strftime("%Y-%m-%d"),
      starts_at_time: Time.now.strftime("%H:%M:%S"),
      ends_at_time: (Time.now + 3600).strftime("%H:%M:%S"),
      room_ids: ['1'], 
    }
  }

  describe "events_between" do
    let(:daily_recurring_event) { FactoryGirl.create(:daily_recurring_event) }

    before(:all) do
      Event.destroy_all
    end

    context "daily event present" do
      it "finds 7 occurrences in a week for a weekly schedule", skip_before: true do
        occurrences = Event.events_between(daily_recurring_event.starts_at, daily_recurring_event.starts_at + 6.days)
        expect(occurrences.count).to eq(7)
        expect(occurrences.first).to be_instance_of(EventOccurrence)
        expect(occurrences.first.starts_occurring_at).to eq(daily_recurring_event.starts_at)
        occurrences.each do |o|
          expect(o.event).to eq(daily_recurring_event)
        end
        expect(occurrences.second.starts_occurring_at).to eq(daily_recurring_event.starts_at + 1.days)
      end
    end

    context "daily and weekly event present" do
      it "finds 8 occurrences in a week", skip_before: true do
        weekly_recurring_event = FactoryGirl.create(:weekly_recurring_event)
        occurrences = Event.events_between(daily_recurring_event.starts_at, daily_recurring_event.starts_at + 6.days)
        expect(occurrences.count).to eq(8)
        expect(occurrences.first.event).to eq(weekly_recurring_event)
      end
    end
  end

  describe "upcoming_events" do

    before(:all) do
      Event.destroy_all
    end

    context "daily event present" do
      it "finds the next 5 upcoming event occurrences", skip_before: true do
        upcoming_daily_recurring_event = FactoryGirl.create(:upcoming_daily_recurring_event)
        occurrences = Event.upcoming_events(5)
        expect(occurrences.count).to eq(5)
        occurrences.each do |o|
          expect(o.event).to eq(upcoming_daily_recurring_event)
        end
      end

      it "finds the next 5 upcoming event occurrences from multiple events", skip_before: true do
        upcoming_daily_recurring_event = FactoryGirl.create(:upcoming_daily_recurring_event)
        upcoming_daily_recurring_event2 = FactoryGirl.create(:upcoming_daily_recurring_event2)
        occurrences = Event.upcoming_events(5)
        expect(occurrences.count).to eq(5)
        expect(occurrences.first.event).to eq(upcoming_daily_recurring_event)
        expect(occurrences.second.event).to eq(upcoming_daily_recurring_event2)
        expect(occurrences.third.event).to eq(upcoming_daily_recurring_event)
        expect(occurrences.fourth.event).to eq(upcoming_daily_recurring_event2)
        expect(occurrences.fifth.event).to eq(upcoming_daily_recurring_event)
      end
    end
  end

  describe "schedule_from_rule" do
    it "sets a schedule and rule" do
      weekly_recurring_event = FactoryGirl.create(:weekly_recurring_event)
      termination_date = weekly_recurring_event.starts_at.to_date.advance(weeks: 1)
      dirty_rule = '{"interval":1, "validations": {"day": [0,1,2,3,4,5,6]}, "rule_type": "IceCube::WeeklyRule"}'
      weekly_recurring_event.schedule_from_rule(dirty_rule, termination_date.to_s)
      expect(weekly_recurring_event.schedule.occurs_on?(termination_date)).to be
      expect(weekly_recurring_event.schedule.occurs_at?(weekly_recurring_event.starts_at.advance(weeks: 1))).to be
      expect(weekly_recurring_event.schedule.occurs_at?(weekly_recurring_event.starts_at.advance(weeks: 1, days: 1))).not_to be
    end
  end

  it "should have options_for_sorted_by" do
    Event::options_for_sorted_by
  end

  it "has a valid factory" do
    expect(event).to be_valid
  end

  it "should have the :is_private attribute" do
    event.is_private == true or event.is_private == false
  end

  context "schedule is not set" do
    it "schedule returns single occurence schedule" do
      expect(event.schedule).to_not be_nil
    end

    it "occurence rule returns nil" do
      expect(event.occurence_rule).to be_nil
    end

    it "string formatting is valid" do
      expect(event.pretty_schedule).to eq(I18n.t 'events.show.schedule_not_recurring')
    end
  end

  context "schedule is non-recurring" do
    let(:schedule_not_recurring) { IceCube::Schedule.new(now = Time.now) }
    let(:event_with_schedule) { FactoryGirl.create(:event, schedule: schedule_not_recurring) }

    it "schedule is set" do
      expect(event_with_schedule.schedule.to_yaml).to eq(schedule_not_recurring.to_yaml)
    end

    it "occurence rule returns nil" do
      expect(event_with_schedule.occurence_rule).to be_nil
    end

    it "has no termination date" do
      expect(event_with_schedule.schedule_ends_at_date).to be_nil
    end

    it "string formatting is valid" do
      expect(event_with_schedule.pretty_schedule).to eq(I18n.t 'events.show.schedule_not_recurring')
    end
  end

  context "schedule is recurring" do
    let(:daily_recurring_event) { FactoryGirl.create(:daily_recurring_event) }

    it "and occurence rule is set" do
      expect(daily_recurring_event.occurence_rule).to eq(IceCube::Rule.daily)
    end

    it "and string formatting is valid" do
      expect(daily_recurring_event.pretty_schedule).to eq(daily_recurring_event.schedule.to_s)
    end
  end

  context "schedule is recurring and terminating" do
    let(:daily_recurring_terminating_event) { FactoryGirl.create(:daily_recurring_terminating_event) }

    it "and occurence rule is set" do
      expect(daily_recurring_terminating_event.schedule_ends_at_date).to eq(Date.new(2015, 8, 15))
    end

    it "and there is no event occurrence after the termination date (inclusive)" do
      event_times = Event.events_between(daily_recurring_terminating_event.starts_at, Date.new(2015, 8, 15).advance(weeks: 1))
      expect(event_times.size).to eq(15)
    end
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
end

describe "checkVacancy" do
  before(:all) do 
    FactoryGirl.create(:room1)
    FactoryGirl.create(:room2)
    @scheduledEvent = FactoryGirl.create(:scheduledEvent)
  end 

  it "should find overlapping events" do
    ## Case 1: same timeslot
    @event2 = FactoryGirl.create(:conflictingEvent, :rooms => @scheduledEvent.rooms)
    colliding_events = @event2.check_vacancy(@scheduledEvent.id, @scheduledEvent.rooms.map(&:id))
    expect(colliding_events.size).to eq 1
    expect(colliding_events[0].name).to eq "Eventname"

    ## Case 2: same timeslots, but different rooms, results to no conflicts (
    @event2.rooms = []
    colliding_events = @event2.check_vacancy(@scheduledEvent.id, [@scheduledEvent[:room_id].to_s])
    expect(colliding_events.size).to eq 0

    @event2.destroy
  end

  it "does not return the original event as a conflict" do 
    colliding_events = @scheduledEvent.check_vacancy(@scheduledEvent.id, @scheduledEvent.rooms.map(&:id))
    expect(colliding_events).not_to include(@scheduledEvent.id)
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

    it "without rooms should be invalid" do
        invalid_event = build(:invalid_event_without_rooms)
        expect(invalid_event).not_to be_valid
    end

  end
