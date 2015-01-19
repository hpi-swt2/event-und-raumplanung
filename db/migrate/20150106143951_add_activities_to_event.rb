class AddActivitiesToEvent < ActiveRecord::Migration
  def change
  	add_column :activities, :event_id, :integer
  end
end
