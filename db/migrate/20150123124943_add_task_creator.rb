class AddTaskCreator < ActiveRecord::Migration
  def change
    add_column :tasks, :creator_id, :integer
    add_index :tasks, :creator_id
  end
end
