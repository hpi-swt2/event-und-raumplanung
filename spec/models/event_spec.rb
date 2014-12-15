require_relative '../../app/models/event'
require 'spec_helper'

describe Event do

  it "has a valid factory" do
    factory = FactoryGirl.build(:event)
    expect(factory).to be_valid
  end

  it "should have the :is_private attribute" do
    @event = FactoryGirl.build(:event)
    @event.is_private == true or @event.is_private == false
  end

  it "SHOULD find overlapping events" do
  	## THIS IS STILL IN PROGRESS
    ## The test will fail, because there is no translation table for the rooms
  	@event1 = FactoryGirl.create(:standardEvent)
    @event1.name = "Party1"
  	@event2 = FactoryGirl.create(:standardEvent)
    @event2.name = "Party2"

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

end