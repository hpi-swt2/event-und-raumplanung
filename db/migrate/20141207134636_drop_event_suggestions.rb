class DropEventSuggestions < ActiveRecord::Migration
  def change
  	drop_table :event_suggestions
  end
end
