require 'test_helper'

class RoomTest < ActiveSupport::TestCase

  test "should return one upcoming event" do
    room = FactoryGirl.create(:room, :id => 42)
    assert_equal 0, room.upcoming_events.size
    event = FactoryGirl.create(:upcoming_event, :room_id => 42)
    assert_equal 1, room.upcoming_events.size
  end

end
