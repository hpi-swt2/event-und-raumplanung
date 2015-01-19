class CreateEventOccurrences < ActiveRecord::Migration
  def change
    create_table :event_occurrences do |t|
      t.references :event, index: true
      t.datetime :starts_occurring_at
      t.datetime :ends_occurring_at

      t.timestamps
    end
  end
end
