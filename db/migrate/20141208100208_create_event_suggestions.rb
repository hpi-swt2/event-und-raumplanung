class CreateEventSuggestions < ActiveRecord::Migration
  def change
    create_table :event_suggestions do |t|
      t.string :starts_at
      t.string :datetime
      t.string :ends_at
      t.string :datetime
      t.string :status
      t.integer :room_id

      t.timestamps
    end
  end
end
