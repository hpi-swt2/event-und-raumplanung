class DropEventSuggestions < ActiveRecord::Migration
  def change
  	drop_table :event_suggestions
  	drop_table :event_suggestions_rooms
  end
end
