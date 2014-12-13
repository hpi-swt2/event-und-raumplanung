require_relative '../../app/models/event'
require 'spec_helper'

describe Event do

	before(:all) do
	  @open_event = FactoryGirl.create(:event)
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
		@open_event.destroy
		@declined_event.destroy
		@approved_event.destroy
	end

end
