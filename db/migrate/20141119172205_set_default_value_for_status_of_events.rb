class SetDefaultValueForStatusOfEvents < ActiveRecord::Migration
  def change
  	change_column_default :events, :status, "In Bearbeitung"
  end
end
