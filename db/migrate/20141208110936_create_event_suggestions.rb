class CreateEventSuggestions < ActiveRecord::Migration
  def change
    create_table :event_suggestions do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :status
      t.timestamps
    end
  	add_reference :event_suggestions, :room, index: true 		  	
    add_reference :event_suggestions, :user, index: true

  end
end
