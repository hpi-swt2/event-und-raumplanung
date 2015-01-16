class DropEventSuggestionIdColumnInEvents < ActiveRecord::Migration
  def change
  	remove_column :events, :event_suggestion_id
  end
end
