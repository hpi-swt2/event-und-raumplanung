require_relative '../../app/models/room'
require 'spec_helper'

describe Room do

  before do
    @room = FactoryGirl.create(:room)
  end

  it "should return upcoming events" do
    event = FactoryGirl.create(:upcoming_event)
    expect(@room.upcoming_events.size).to eq(0)
    event.rooms << @room
    expect(@room.upcoming_events.size).to eq(1)
  end

  it "should list rooms properties" do
    property = FactoryGirl.create(:room_property)
    expect(@room.list_properties).to eq('')
    @room.properties << property
    expect(@room.list_properties).to eq(property.name)
  end

  it "should assign room_property to room" do
    property = FactoryGirl.create(:room_property)
    @room.properties << property
    expect(@room.properties).to include(property)
    expect(property.rooms).to include(@room)
  end

end