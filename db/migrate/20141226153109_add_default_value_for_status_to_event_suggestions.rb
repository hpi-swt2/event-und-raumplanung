class AddDefaultValueForStatusToEventSuggestions < ActiveRecord::Migration
  def change
  	change_column :event_suggestions, :status, :string, :default => 'pending'
  end
end
