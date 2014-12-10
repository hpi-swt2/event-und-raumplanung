class CreateEventTemplatsRooms < ActiveRecord::Migration
  def change
    create_table :event_templates_rooms do |t|
      t.belongs_to :event_template
      t.belongs_to :room
    end
  end
end
