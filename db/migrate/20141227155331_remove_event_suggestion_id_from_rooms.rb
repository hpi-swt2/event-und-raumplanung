class RemoveEventSuggestionIdFromRooms < ActiveRecord::Migration
  def change
  	remove_column :rooms, :event_suggestion_id
  end
end
