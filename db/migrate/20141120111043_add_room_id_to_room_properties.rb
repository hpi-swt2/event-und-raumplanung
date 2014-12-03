class AddRoomIdToRoomProperties < ActiveRecord::Migration
  def change
    add_column :room_properties, :room_id, :integer
  end
end
