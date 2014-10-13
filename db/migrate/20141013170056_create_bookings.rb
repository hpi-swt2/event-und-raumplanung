class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :name
      t.string :description
      t.datetime :start
      t.datetime :end
      t.references :event, index: true
      t.references :room, index: true

      t.timestamps
    end
  end
end
