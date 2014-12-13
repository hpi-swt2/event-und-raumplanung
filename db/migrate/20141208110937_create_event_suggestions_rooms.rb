class CreateEventSuggestionsRooms < ActiveRecord::Migration
  def change
    create_table :event_suggestions_rooms do |t|
    	t.belongs_to :event_suggestion
      	t.belongs_to :room
    end
  end
end
