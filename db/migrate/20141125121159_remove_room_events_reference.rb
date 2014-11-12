class RemoveRoomEventsReference < ActiveRecord::Migration
  def change
    remove_reference :rooms, :event
  end
end
