class AddEventSuggestionReferenceToEvents < ActiveRecord::Migration
  def change
  	add_reference :events, :event_suggestion, references: :events
  end
end
