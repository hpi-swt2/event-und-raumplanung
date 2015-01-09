class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :username
      t.string :action
      t.string :controller
      t.text :task_info
      t.text :changed_fields

      t.timestamps
    end
  end
end
