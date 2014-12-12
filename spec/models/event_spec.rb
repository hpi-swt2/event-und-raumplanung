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

end