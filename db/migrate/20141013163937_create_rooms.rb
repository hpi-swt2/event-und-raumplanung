class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :size
      t.references :booking, index: true

      t.timestamps
    end
  end
end
