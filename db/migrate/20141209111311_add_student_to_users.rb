class AddStudentToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :student, :boolean
  end
end
