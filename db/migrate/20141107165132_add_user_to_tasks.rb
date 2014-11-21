class AddUserToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :user, index: true
  end
end
