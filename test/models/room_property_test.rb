require 'test_helper'

class RoomPropertyTest < ActiveSupport::TestCase
  
  test "should assign room to room_property" do
    property = room_properties(:one)
    room = rooms(:one)
    property.rooms << room
    assert property.rooms.include?(room)
    assert room.properties.include?(property)
  end

end
