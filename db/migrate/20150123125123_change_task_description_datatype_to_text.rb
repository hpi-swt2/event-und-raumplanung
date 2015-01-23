class ChangeTaskDescriptionDatatypeToText < ActiveRecord::Migration
  def change
  	change_column :tasks, :description, :text
  end
end
