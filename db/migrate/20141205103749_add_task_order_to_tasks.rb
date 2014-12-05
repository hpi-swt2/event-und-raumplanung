class AddTaskOrderToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_order, :integer
  end
end
