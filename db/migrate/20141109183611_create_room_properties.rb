class CreateRoomProperties < ActiveRecord::Migration
  def change
    create_table :room_properties do |t|
      t.string :name

      t.timestamps
    end
  end
end
