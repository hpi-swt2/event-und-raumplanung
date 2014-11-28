class CreateEventsRooms < ActiveRecord::Migration
  def change
    create_table :events_rooms do |t|
      t.belongs_to :event
      t.belongs_to :room
    end
  end
end
