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

  it "should be private by default" do
    event = build(:event)
    expect(event.is_private).to be true
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