class AddEventSuggestionsToRooms < ActiveRecord::Migration
  def change
   add_reference :rooms, :event_suggestion, index: true
  end
end
