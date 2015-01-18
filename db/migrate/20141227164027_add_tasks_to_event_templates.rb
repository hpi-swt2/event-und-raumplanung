class AddTasksToEventTemplates < ActiveRecord::Migration
  def change
  	add_reference :tasks, :event_template, index: true 		  	
  end
end
