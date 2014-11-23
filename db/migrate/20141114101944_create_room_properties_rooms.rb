class CreateRoomPropertiesRooms < ActiveRecord::Migration
  def change
    create_table :room_properties_rooms do |t|
      t.belongs_to :room_property
      t.belongs_to :room
    end
  end
end
