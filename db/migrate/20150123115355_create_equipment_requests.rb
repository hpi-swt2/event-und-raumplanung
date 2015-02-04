class CreateEquipmentRequests < ActiveRecord::Migration
  def change
    create_table :equipment_requests do |t|
      t.integer :event_id
      t.integer :room_id
      t.string :category
      t.integer :count

      t.timestamps
    end
  end
end
