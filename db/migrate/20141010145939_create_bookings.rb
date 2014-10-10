class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :name
      t.string :description
      t.timestamp :start
      t.timestamp :stop

      t.timestamps
    end
  end
end
