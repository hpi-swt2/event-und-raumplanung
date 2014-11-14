require 'test_helper'

class RoomTest < ActiveSupport::TestCase

  setup do
    @room = rooms(:one)
  end

  test "should return upcoming events" do
    assert_equal 0, @room.upcoming_events.size
    event = FactoryGirl.create(:upcoming_event, :room_id => @room.id)
    assert_equal 1, @room.upcoming_events.size
    event2 = FactoryGirl.create(:past_event, :room_id => @room.id)
    assert_equal 1, @room.upcoming_events.size
  end

  test "should list rooms properties" do
    assert_equal '', @room.list_properties
    property = room_properties(:one)
    @room.properties << property
    assert_equal property.name, @room.list_properties
  end

  test "should assign room_property to room" do
    property = room_properties(:one)
    @room.properties << property
    assert @room.properties.include?(property)
    assert property.rooms.include?(@room)
  end

end
