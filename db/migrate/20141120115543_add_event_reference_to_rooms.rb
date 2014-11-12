class AddEventReferenceToRooms < ActiveRecord::Migration
  def change
  	  	add_reference :rooms, :event, index: true 		  	
  end
end
