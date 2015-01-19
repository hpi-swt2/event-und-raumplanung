class AddEventToEventSuggestions < ActiveRecord::Migration
  def change
  	 add_reference :event_suggestions, :event, index: true 		  	
  end
end
