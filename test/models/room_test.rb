require 'test_helper'

class RoomTest < ActiveSupport::TestCase

  test "should return one upcoming event" do
    room = rooms(:one)
    assert_equal 0, room.upcoming_events.size
    event = FactoryGirl.create(:upcoming_event, :room_id => room.id)
    assert_equal 1, room.upcoming_events.size
    event2 = FactoryGirl.create(:past_event, :room_id => room.id)
    assert_equal 1, room.upcoming_events.size
  end

  test "should assign room_property to room" do
    room = rooms(:one)
    property = room_properties(:one)
    room.properties << property
    assert room.properties.include?(property)
    assert property.rooms.include?(room)
  end

end
