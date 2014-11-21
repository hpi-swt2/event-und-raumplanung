class AddFieldsToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :start_date, :date
  	add_column :events, :end_date, :date
   	add_column :events, :start_time, :time
  	add_column :events, :end_time, :time
  	add_reference :events, :user, index: true
  	add_reference :events, :room, index: true 		  	
  end
end
